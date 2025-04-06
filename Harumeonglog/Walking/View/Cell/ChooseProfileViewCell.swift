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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(imageView)
        imageView.addSubview(checkImageView)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(48)
        }
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
    }
}
