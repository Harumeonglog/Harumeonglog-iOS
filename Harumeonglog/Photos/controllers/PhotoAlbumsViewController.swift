//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25
//

import UIKit
import Alamofire
import SDWebImage

class PhotoAlbumsViewController: UIViewController {

    private lazy var photoAlbumsView: PhotoAlbumsView = {
        let view = PhotoAlbumsView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = photoAlbumsView
        
        fetchAlbums()
        
        photoAlbumsView.albumCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")
        photoAlbumsView.albumCollectionView.delegate = self
        photoAlbumsView.albumCollectionView.dataSource = self
        
    }
    
    private func fetchAlbums() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        PetService.fetchPets(token: token) { [weak self] result in
            switch result {
            case .success(let response):
                print("반려동물 목록 조회 성공!")

                switch response.result {
                case .result(let petResult):
                    let pets = petResult.pets
                    let albums = pets.map {
                        Album(
                            mainImage: $0.mainImage,
                            name: $0.name,
                            photosCount: 0,
                            petId: $0.petId,
                            imageInfos: [],
                            uiImages: []
                        )
                    }
                    self?.photoAlbumsView.albums = albums
                    self?.photoAlbumsView.albumCollectionView.reloadData()

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
    
    //셀 선택했을때 해당 앨범으로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            defer { dispatchGroup.leave() }

                            if let data = data, let image = UIImage(data: data) {
                                images.append(image)
                            } else {
                                images.append(UIImage(named: "placeholder") ?? UIImage())
                            }
                        }.resume()
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

                        let photosVC = PhotosViewController(album: updatedAlbum)
                        self?.navigationController?.pushViewController(photosVC, animated: true)
                    }

                case .message(let msg):
                    print("이미지 조회 실패 메시지: \(msg)")
                case .none:
                    print("이미지 응답 result 값이 없습니다.")
                }
            case .failure(let error):
                print("이미지 목록 불러오기 실패:", error)
            }
        }
    }
}
