//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

class PhotoAlbumsViewController: UIViewController {

    private lazy var photoAlbumsView: PhotoAlbumsView = {
        let view = PhotoAlbumsView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = photoAlbumsView
        
        photoAlbumsView.albumCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")
        photoAlbumsView.albumCollectionView.delegate = self
        photoAlbumsView.albumCollectionView.dataSource = self
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = photoAlbumsView.albums[indexPath.item]
        let photosVC = PhotosViewController(album: album)
        self.navigationController?.pushViewController(photosVC, animated: true)
    }
}
