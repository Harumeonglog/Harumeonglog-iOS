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
        
        // album 예시
        photoAlbumsView.albums = [
            Album(coverImage: UIImage(named: "doggo")!,
                  images: [UIImage(named: "doggo")!, UIImage(named: "doggo")!, UIImage(named: "doggo")!, UIImage(named: "doggo")!,UIImage(named: "doggo")!,UIImage(named: "doggo")!],
                  name: "누룽지",
                  photosCount: 308),
            Album(coverImage: UIImage(named: "doggo")!,
                  images: [UIImage(named: "doggo")!, UIImage(named: "doggo")!],
                  name: "호빵이",
                  photosCount: 10),
            Album(coverImage: UIImage(named: "doggo")!,
                  images: [UIImage(named: "doggo")!, UIImage(named: "doggo")!, UIImage(named: "doggo")!],
                  name: "바보",
                  photosCount: 503),
            Album(coverImage: UIImage(named: "doggo")!,
                  images: [UIImage(named: "doggo")!],
                  name: "나비",
                  photosCount: 283)
        ]
        
        photoAlbumsView.albumCollectionView.reloadData()
    }
}
