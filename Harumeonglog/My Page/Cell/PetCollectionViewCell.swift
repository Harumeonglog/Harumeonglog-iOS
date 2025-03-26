//
//  PetCollectionViewCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/26/25.
//

import UIKit

class PetCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PetCollectionViewCell"
    
    // Owner, Guest 공통 부분
    private lazy var profileImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray02
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .black
    }
    
    private lazy var genderLabel = commonLabel()
    private lazy var divider = UIView().then {
        $0.backgroundColor = .gray01
    }
    private lazy var dogSizeLabel = commonLabel()
    private lazy var birthdayLabel = commonLabel()
    
    private lazy var accessLevelTagImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    public lazy var editButton = UIButton().then {
        $0.setImage(.meatballsMenu, for: .normal)
    }
    
    // Owner 전용 View
    public lazy var memberTableView = UITableView().then {
        $0.backgroundColor = .brown01
    }
    
    public lazy var sendinvitationButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
    }
    
    public func configure(_ petData: PetData) {
        setDefaultConstraints()
        if petData.level == .Guest {
            accessLevelTagImageView.image = .guestTag
        } else {
            accessLevelTagImageView.image = .ownerTag
        }
        profileImage.image = petData.image
        nameLabel.text = petData.name
        genderLabel.text = petData.gender
        dogSizeLabel.text = petData.size.inKorean()
        birthdayLabel.text = "🎂 " + petData.birthday
        
    }
    
    private func setDefaultConstraints() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.addSubview(profileImage)
        self.addSubview(nameLabel)
        self.addSubview(genderLabel)
        self.addSubview(divider)
        self.addSubview(dogSizeLabel)
        self.addSubview(birthdayLabel)
        self.addSubview(accessLevelTagImageView)
        self.addSubview(editButton)
        
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.leading.top.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.top.equalTo(profileImage.snp.top).offset(10)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.centerY.equalTo(profileImage.snp.centerY)
        }
        
        divider.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.leading.equalTo(genderLabel.snp.trailing).offset(7)
            make.centerY.equalTo(genderLabel)
            make.height.equalTo(15)
        }
        
        dogSizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderLabel.snp.trailing).offset(16)
            make.centerY.equalTo(genderLabel)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderLabel)
            make.top.equalTo(dogSizeLabel.snp.bottom).offset(7)
        }
        
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.top.equalTo(profileImage.snp.top).inset(-10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        accessLevelTagImageView.image = .guestTag
        accessLevelTagImageView.snp.makeConstraints { make in
            make.centerY.equalTo(editButton)
            make.trailing.equalTo(editButton.snp.leading)
            make.height.equalTo(25)
            make.width.equalTo(70)
        }
    }
    
    private func addOwnerConstraints() {
        
    }
    
    public func configureOwnerMode() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonLabel() -> UILabel {
        return UILabel().then {
            $0.textColor = .gray01
            $0.font = .systemFont(ofSize: 12)
        }
    }
    
}

struct PetData {
    let level: UserAcessLevelEnum
    let image: UIImage?
    let name: String
    let gender: String
    let size: DogSizeEnum
    let birthday: String
}

enum UserAcessLevelEnum: String {
    case Owner, Guest
    
    func tagImage() -> UIImage {
        switch self {
        case .Owner:
            return .ownerTag
        case .Guest:
            return .guestTag
        }
    }
}

import SwiftUI
#Preview {
    PetListViewController()
}
