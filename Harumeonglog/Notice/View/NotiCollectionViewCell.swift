//
//  NotificationTableViewCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import UIKit

class NotiCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NotificationCollectionViewCell"
    
    private lazy var isReadLightBulb = UIView().then {
        $0.backgroundColor = .blue01
        $0.snp.makeConstraints { make in
            make.height.width.equalTo(4)
        }
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true
    }
    
    private lazy var typeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .blue01
    }
    
    private lazy var userNameLabel = UILabel().then { // Bold처리
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    private lazy var timeLabel = UILabel().then {
        $0.textColor = .gray02
        $0.font = .systemFont(ofSize: 12)
    }
    
    public func configure(_ data: NoticeModel) {
        let type = data.noticeType
        typeImageView.image = type?.typeImage() ?? UIImage(systemName: "sun")
        titleLabel.text = data.content ?? ""
        if type == .COMMENT || type == .ARTICLE {
            // timeLabel.text = data.date
            timeLabel.isHidden = false
        } else {
            timeLabel.isHidden = true
        }
        // 유저 닉네임이 있는 경우
        if data.senderName != nil {
            userNameLabel.snp.makeConstraints { make in
                make.width.greaterThanOrEqualTo(50)
            }
        } else {
            userNameLabel.snp.makeConstraints { make in
                make.width.equalTo(0)
            }
        }
        
        // 시간
        timeLabel.text = DateFormatter.stringToString(from: data.createdAt ?? "")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder )
    }
    
    public func setConstraints() {
        
        let width = UIScreen.main.bounds.width
        
        self.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(width - 56)
        }
        
        self.addSubview(isReadLightBulb)
        self.addSubview(typeImageView)
        self.addSubview(userNameLabel)
        self.addSubview(titleLabel)
        self.addSubview(timeLabel)
        
        isReadLightBulb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(0)
        }
        
        typeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.height.width.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeImageView.snp.trailing).offset(13)
            make.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel.snp.trailing)
            make.trailing.equalTo(timeLabel.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
    
}

import SwiftUI
#Preview {
    NotiViewController()
}
