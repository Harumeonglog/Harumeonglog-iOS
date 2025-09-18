//
//  ProfileCollectionViewCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/23/25.
//

import UIKit
import SnapKit
import Then

class ShowMemberProfileCell: UICollectionViewCell {
    
    static let identifier = "ShowMemberProfileCell"

    public lazy var imageView = UIImageView().then { imageView in
        imageView.image = UIImage.test
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
    }
    
    public lazy var nameLabel = UILabel().then { label in
        label.text = "누렁이"
        label.textColor = .gray00
        label.font = UIFont(name: "Pretendard-Regular", size: 10)
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
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configureMember(with member : WalkMembers) {
        imageView.sd_setImage(with: URL(string: member.image ?? ""), placeholderImage: UIImage(named: "defaultImage"))
        nameLabel.text = member.nickname
    }
    
}



class ShowPetProfileCell: UICollectionViewCell {
    
    static let identifier = "ShowPetProfileCell"

    public lazy var imageView = UIImageView().then { imageView in
        imageView.image = UIImage.test
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
    }
    
    public lazy var nameLabel = UILabel().then { label in
        label.text = "누렁이"
        label.textColor = .gray00
        label.font = UIFont(name: "Pretendard-Regular", size: 10)
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
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    
    func configurePet(with pet : WalkPets) {
        imageView.sd_setImage(with: URL(string: pet.image ?? ""), placeholderImage: UIImage(named: "defaultImage"))
        nameLabel.text = pet.name
    }
}
