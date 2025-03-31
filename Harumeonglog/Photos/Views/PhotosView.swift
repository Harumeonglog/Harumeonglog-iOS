//
//  PhotosView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//

import UIKit
import SnapKit

class PhotosView: UIView {
    
    lazy var PhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 120) 
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = nil
        collectionView.delegate = nil
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PictureCell")
        collectionView.backgroundColor = .clear
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
    }
}
