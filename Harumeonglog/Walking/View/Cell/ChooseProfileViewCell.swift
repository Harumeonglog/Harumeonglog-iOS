//
//  ChooseProfileViewCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 4/6/25.
//

import UIKit
import SnapKit
import Then

class ChooseProfileViewCell: UICollectionViewCell {
    
    static let identifier = "ChooseProfileViewCell"

    public lazy var imageView = UIImageView().then { imageView in
        imageView.image = UIImage.test
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
    }
    
    private lazy var dimmedView = UIView().then { view in
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
    }
    
    public lazy var checkImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .blue01
        imageView.isHidden = true
    }
    
    public lazy var nameLabel = UILabel().then { label in
        label.text = "누렁이"
        label.textColor = .gray00
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textAlignment = .center
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.layer.borderColor = UIColor.blue01.cgColor
                imageView.layer.borderWidth = 2
                checkImageView.isHidden = false
                dimmedView.isHidden = false
            }
            else {
                imageView.layer.borderColor = nil
                imageView.layer.borderWidth = 0
                imageView.backgroundColor = nil
                checkImageView.isHidden = true
                dimmedView.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(imageView)
        imageView.addSubview(dimmedView)
        imageView.addSubview(checkImageView)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(48)
        }
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(7)
            make.leading.trailing.equalToSuperview()
        }
    }
}
