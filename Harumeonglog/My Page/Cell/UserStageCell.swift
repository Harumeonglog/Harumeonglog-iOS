//
//  UserStageCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/7/25.
//

import UIKit

class UserStageCell: UICollectionViewCell {
    
    static let identifier: String = "UserStageCell"
    
    private lazy var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
        
    private lazy var nicknameLabel = UILabel().then {
        $0.font = UIFont.body
        $0.textColor = .black
    }
    
    public lazy var userLevelToggleButton = UserLevelToggleButton()
    
    public lazy var deletionButton = UIButton().then {
        $0.setImage(.cancel, for: .normal)
    }
    
    public func configure(data: UserStageData) {
        profileImageView.image = data.userProfile
        nicknameLabel.text = data.username
        userLevelToggleButton.setUserLevel(data.userLevel)
    }
    
    private func setConstraints() {
        self.addSubview(profileImageView)
        self.addSubview(nicknameLabel)
        self.addSubview(userLevelToggleButton)
        self.addSubview(deletionButton)
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(50)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(13)
        }
        
        deletionButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        
        userLevelToggleButton.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(deletionButton.snp.leading)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

import SwiftUI
#Preview {
    InviteUserViewController()
}
