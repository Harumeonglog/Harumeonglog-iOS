//
//  PhotoDetailView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//
import UIKit
import SnapKit

class PhotoDetailView: UIView {
    private let imageView: UIImageView
    
    public lazy var navigationBar = CustomNavigationBar()

    init(image: UIImage, album: Album) {
        self.imageView = UIImageView(image: image)
        super.init(frame: .zero)
        backgroundColor = .background
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(navigationBar)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(imageView.snp.width)
        }
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
