//
//  PhotosView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//

import UIKit
import SnapKit

class PhotosView: UIView {
    
    public lazy var navigationBar = CustomNavigationBar()
    
    lazy var PhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = nil
        collectionView.delegate = nil
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PictureCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let bottomActionBar : UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray04.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .bg
        view.isHidden = true
        return view
    }()
    
    let downloadButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down.to.line.compact"), for: .normal)
        button.tintColor = .gray00
        return button
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .gray00
        return button
    }()
    
    var selectedCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0장의 사진이 선택됨"
        label.font = .body
        label.textColor = .gray00
        label.textAlignment = .center
        return label
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
        addSubview(navigationBar)
        addSubview(PhotosCollectionView)
        addSubview(bottomActionBar)
        bottomActionBar.addSubview(downloadButton)
        bottomActionBar.addSubview(deleteButton)
        bottomActionBar.addSubview(selectedCountLabel)

        
        PhotosCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(47+16)
            make.leading.trailing.equalToSuperview().inset(13)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(35)
        }
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        bottomActionBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(87)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(33)
            make.bottom.equalToSuperview().inset(37)
            make.width.height.equalTo(24)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(33)
            make.centerY.equalTo(downloadButton)
            make.width.height.equalTo(24)
        }
        
        selectedCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(downloadButton)
            make.centerX.equalToSuperview()
            make.height.equalTo(21)
        }
    }
}
