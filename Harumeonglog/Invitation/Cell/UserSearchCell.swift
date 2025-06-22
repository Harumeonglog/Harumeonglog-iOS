//
//  UserSearchCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/22/25.
//

import UIKit

class UserSearchCell: UITableViewCell {
    
    private var mamber: Member?
    static let identifier: String = "UserSearchCell"
    
    private lazy var emailLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .black
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .systemGray
    }
    
    public func configure(with member: Member) {
        self.mamber = member
        emailLabel.text = member.email
        userNameLabel.text = member.name
        setConstraints()
    }
    
    private func setConstraints() {
        self.addSubview(emailLabel)
        self.addSubview(userNameLabel)
        
        emailLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(150)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(emailLabel.snp.trailing).offset(20)
        }
    }
    
}
