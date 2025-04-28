//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
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
        PetService.fetchPets(completion: { result in
            switch result {
            case .success(let response):
                switch response.result {
                case .result(let petResult):
                    let pets = petResult.pets
                    let albums = pets.map {
                        Album(
                            coverImage: UIImage(),
                            images: [],
                            name: $0.name,
                            photosCount: 0,
                            mainImageURL: $0.mainImage,
                            petId: $0.petId
                        )
                    }
                    self.photoAlbumsView.albums = albums
                    self.photoAlbumsView.albumCollectionView.reloadData()
                    
                case .message(let msg):
                    print("result 메시지: \(msg)")
                case .none:
                    print("result 없음")
                }
            case .failure(let error):
                debugPrint("반려동물 조회 실패: \(error)")
            }
        })
    }
    
    private func uploadImages(for petId: Int, imageKeys: [String]) {
        PhotoService.uploadPetImages(petId: petId, imageKeys: imageKeys, token: nil) { result in
            switch result {
            case .success(let response):
                print("업로드 성공:", response.result.imageIds)
            case .failure(let error):
                print("업로드 실패:", error)
            }
        }
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

        PhotoService.fetchPetImages(petId: petId, cursor: 0, size: 100) { [weak self] result in
            switch result {
            case .success(let response):
                switch response.result {
                case .result(let result):
                    let imageUrls = result.images.map { $0.imageKey }
                    let images: [UIImage] = imageUrls.compactMap { urlString in
                        guard let url = URL(string: urlString),
                              let data = try? Data(contentsOf: url),
                              let image = UIImage(data: data) else { return nil }
                        return image
                    }

                    let updatedAlbum = Album(
                        coverImage: images.first ?? UIImage(),
                        images: images,
                        name: album.name,
                        photosCount: images.count,
                        mainImageURL: album.mainImageURL,
                        petId: album.petId
                    )

                    DispatchQueue.main.async {
                        let photosVC = PhotosViewController(album: updatedAlbum)
                        self?.navigationController?.pushViewController(photosVC, animated: true)
                    }

                case .message(let msg):
                    print("서버 메시지: \(msg)")

                case .none:
                    print("이미지 result 없음")
                }
            case .failure(let error):
                print("이미지 목록 불러오기 실패:", error)
            }
        }
    }
}
