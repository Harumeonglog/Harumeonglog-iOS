//
//  InvitationCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import UIKit

class InvitationCell: UICollectionViewCell {
    
    static let identifier = "InvitationCollectionViewCell"
    
    private lazy var profileImage = UIImageView().then {
        $0.backgroundColor = .gray03
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.textColor = .black
    }
    
    public lazy var confirmButton = UIButton().then {
        $0.backgroundColor = .blue01
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    public lazy var deleteButton = UIButton().then {
        $0.backgroundColor = .background
        $0.layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.logout, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    public func configure(_ data: InvitationModel) {
        nameLabel.text = data.nickname
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    private func setConstraints() {
        self.addSubview(profileImage)
        self.addSubview(nameLabel)
        self.addSubview(confirmButton)
        self.addSubview(deleteButton)
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(25)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.trailing.equalTo(deleteButton.snp.leading).offset(-9)
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

import SwiftUI
#Preview {
    InvitationViewController()
}
