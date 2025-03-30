//
//  ProfileCollectionViewCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/23/25.
//

import UIKit
import SnapKit
import Then

class ProfileCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProfileCollectionViewCell"

    public lazy var imageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "person.circle")
        imageView.layer.cornerRadius = 25
    }
    
    public lazy var nameLabel = UILabel().then { label in
        label.text = "누렁이"
        label.textColor = .gray00
        label.font = UIFont(name: "Pretendard-Regular", size: 9)
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
        self.addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
    }
}
