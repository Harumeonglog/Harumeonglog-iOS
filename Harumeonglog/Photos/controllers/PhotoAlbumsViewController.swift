//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25
//

import UIKit
import Alamofire
import SDWebImage
import Combine

class PhotoAlbumsViewController: UIViewController {

    private lazy var photoAlbumsView: PhotoAlbumsView = {
        let view = PhotoAlbumsView()
        return view
    }()
    
    private var isLoading = false
    private var hasLoadedOnce = false
    private var isOpeningAlbum = false
    
    // 앨범의 사진 개수를 캐싱하는 딕셔너리
    private var photoCountCache: [Int: Int] = [:]
    
    // 캐시 유효 시간 (초)
    private let cacheValidityDuration: TimeInterval = 300 // 5분
    
    // 구독 저장하는 Set
    private lazy var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = photoAlbumsView
        
        fetchAlbums()
        
        photoAlbumsView.albumCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")
        photoAlbumsView.albumCollectionView.delegate = self
        photoAlbumsView.albumCollectionView.dataSource = self
        
        PetListViewModel.shared.$petList
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.fetchAlbums()
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 돌아올 때는 불필요한 재로딩 방지: 처음이거나 데이터가 없을 때만 로딩
        if !isLoading && !hasLoadedOnce && photoAlbumsView.albums.isEmpty {
            fetchAlbums()
        }
    }
    
    private func fetchAlbums() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        isLoading = true

        PetService.fetchPets(token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            switch result {
            case .success(let response):
                print("반려동물 목록 조회 성공!")

                switch response.result {
                case .result(let petResult):
                    let pets = petResult.pets
                    let albums = pets.filter { $0.role != "GUEST" }.map { pet in
                        Album(
                            mainImage: pet.mainImage,
                            name: pet.name,
                            photosCount: 0, 
                            petId: pet.petId,
                            imageInfos: [],
                            uiImages: []
                        )
                    }
                    
                    // 즉시 UI에 앨범 목록 표시 (사진 개수는 0으로 표시)
                    DispatchQueue.main.async {
                        self?.photoAlbumsView.albums = albums
                        self?.photoAlbumsView.albumCollectionView.reloadData()
                    }
                    
                    // 백그라운드에서 각 앨범의 사진 개수 조회
                    self?.fetchPhotoCountsForAlbums(albums: albums, token: token)
                    self?.hasLoadedOnce = true

                case .message(let msg):
                    print("서버 응답 메시지: \(msg)")
                    self?.photoAlbumsView.albums = []
                    self?.photoAlbumsView.albumCollectionView.reloadData()

                case .none:
                    print("result가 없습니다.")
                }

            case .failure(let error):
                debugPrint("반려동물 조회 실패: \(error)")
            }
        }
    }
    
    // 각 앨범의 사진 개수를 조회하는 메서드 (최적화된 버전)
    private func fetchPhotoCountsForAlbums(albums: [Album], token: String) {
        // 모든 앨범의 사진 개수를 동시에 조회 (병렬 처리)
        let dispatchGroup = DispatchGroup()
        
        for (index, album) in albums.enumerated() {
            // 캐시된 사진 개수가 있으면 즉시 사용
            if let cachedCount = photoCountCache[album.petId] {
                DispatchQueue.main.async {
                    self.updateAlbumPhotoCount(at: index, count: cachedCount)
                }
                continue
            }
            
            dispatchGroup.enter()
            
            // 더 큰 size로 한 번에 조회하여 전체 개수 파악
            PhotoService.fetchPetImages(petId: album.petId, cursor: 0, size: 1000, token: token) { [weak self] result in
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let response):
                    switch response.result {
                    case .result(let result):
                        let totalCount = result.images.count
                        
                        // 캐시에 저장
                        self?.photoCountCache[album.petId] = totalCount
                        
                        // 즉시 UI 업데이트 (점진적 업데이트)
                        DispatchQueue.main.async {
                            self?.updateAlbumPhotoCount(at: index, count: totalCount)
                        }
                        
                    case .message(let msg):
                        print("앨범 \(album.name) 사진 개수 조회 실패: \(msg)")
                    case .none:
                        print("앨범 \(album.name) 사진 개수 응답 result가 없습니다.")
                    }
                case .failure(let error):
                    print("앨범 \(album.name) 사진 개수 조회 실패: \(error)")
                }
            }
        }
        
        // 모든 앨범의 사진 개수 조회가 완료되면 최종 UI 업데이트
        dispatchGroup.notify(queue: .main) { [weak self] in
            print("모든 앨범의 사진 개수 조회 완료")
        }
    }
    
    // 앨범의 사진 개수를 업데이트하는 헬퍼 메서드
    private func updateAlbumPhotoCount(at index: Int, count: Int) {
        if index < photoAlbumsView.albums.count {
            let album = photoAlbumsView.albums[index]
            photoAlbumsView.albums[index].photosCount = count
            
            // 캐시 업데이트
            photoCountCache[album.petId] = count
            
            // 특정 셀만 업데이트하여 성능 향상
            photoAlbumsView.albumCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    // PhotosViewController에서 호출할 수 있는 public 메서드
    func updateAlbumPhotoCount(for petId: Int, count: Int) {
        if let index = photoAlbumsView.albums.firstIndex(where: { $0.petId == petId }) {
            photoAlbumsView.albums[index].photosCount = count
            
            // 캐시 업데이트
            photoCountCache[petId] = count
            
            // 특정 셀만 업데이트하여 성능 향상
            photoAlbumsView.albumCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            print("앨범 \(photoAlbumsView.albums[index].name)의 사진 개수를 \(count)로 업데이트했습니다.")
        }
    }
    
    // 캐시 무효화 메서드
    func invalidatePhotoCountCache() {
        photoCountCache.removeAll()
    }
    
    // 특정 앨범의 캐시만 무효화
    func invalidatePhotoCountCache(for petId: Int) {
        photoCountCache.removeValue(forKey: petId)
    }
    
    private func uploadImages(for petId: Int, imageKeys: [String]) {
        
    }
    
    @objc private func addButtonTapped() {
        let dummyImageKeys = ["test_image_01.jpg", "test_image_02.jpg"]
        let petId = 1 // 실제 선택된 반려견 ID로 교체해야 함
        uploadImages(for: petId, imageKeys: dummyImageKeys)
    }
}

//컬렉션뷰 delegate, datasource
extension PhotoAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAlbumsView.albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let album = photoAlbumsView.albums[indexPath.item]
        cell.configure(with: album)
        return cell
    }
    
    // Dynamic full-width cell sizing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    //셀 선택했을때 해당 앨범으로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isOpeningAlbum { return }
        isOpeningAlbum = true
        let album = photoAlbumsView.albums[indexPath.item]
        let petId = album.petId
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
                print("토큰이 없습니다.")
                return
            }

        PhotoService.fetchPetImages(petId: petId, cursor: 0, size: 100, token: token) { [weak self] result in
            switch result {
            case .success(let response):
                print("특정 반려동물 이미지 목록 불러오기 성공: \(petId)")
                switch response.result {
                case .result(let result):
                    var images: [UIImage] = []
                    let dispatchGroup = DispatchGroup()

                    for urlString in result.images.map({ $0.imageKey }) {
                        guard let url = URL(string: urlString) else {
                            images.append(UIImage(named: "placeholder") ?? UIImage())
                            continue
                        }

                        dispatchGroup.enter()
                        SDWebImageManager.shared.loadImage(
                            with: url,
                            options: [.retryFailed, .continueInBackground, .scaleDownLargeImages],
                            progress: nil
                        ) { image, data, error, cacheType, finished, imageURL in
                            defer { dispatchGroup.leave() }
                            if let image = image {
                                images.append(image)
                            } else {
                                images.append(UIImage(named: "placeholder") ?? UIImage())
                            }
                        }
                    }

                    dispatchGroup.notify(queue: .main) {
                        let updatedAlbum = Album(
                            mainImage: album.mainImage,
                            name: album.name,
                            photosCount: images.count,
                            petId: album.petId,
                            imageInfos: result.images,
                            uiImages: images
                        )

                        // 앨범 목록에서 해당 앨범의 사진 개수 업데이트
                        if let index = self?.photoAlbumsView.albums.firstIndex(where: { $0.petId == album.petId }) {
                            self?.photoAlbumsView.albums[index].photosCount = images.count
                            self?.photoAlbumsView.albumCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                            print("앨범 \(album.name)의 사진 개수를 \(images.count)로 업데이트했습니다.")
                        }

                        let photosVC = PhotosViewController(album: updatedAlbum)
                        photosVC.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(photosVC, animated: true)
                        self?.isOpeningAlbum = false
                    }

                case .message(let msg):
                    print("이미지 조회 실패 메시지: \(msg)")
                    self?.isOpeningAlbum = false
                case .none:
                    print("이미지 응답 result 값이 없습니다.")
                    self?.isOpeningAlbum = false
                }
            case .failure(let error):
                print("이미지 목록 불러오기 실패:", error)
                self?.isOpeningAlbum = false
            }
        }
    }
}
