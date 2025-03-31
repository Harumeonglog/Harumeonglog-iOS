//
//  PhotosView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//

import UIKit
import SnapKit

class PhotosView: UIView {
    
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .brown01
        button.backgroundColor = .brown02
        return button
    }()
    
    lazy var PhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 120) // Image size
        layout.minimumInteritemSpacing = 8 // Spacing between items
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PictureCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bg
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        addSubview(PhotosCollectionView)
        
        PhotosCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(125)
            make.leading.trailing.equalToSuperview().inset(13)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(35)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(120)
        }
    }
}
