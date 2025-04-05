//
//  PhotoDetailViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage, album: Album) {
        self.image = image
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = photoDetailView
        setCustomNavigationBarConstraints()
    }
    
    var image: UIImage
    var album: Album

    
    private lazy var photoDetailView: PhotoDetailView = {
        let view = PhotoDetailView(image:image, album: album)
        return view
    }()
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = photoDetailView.navigationBar
        navi.configureTitle(title: album.name)
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
}
