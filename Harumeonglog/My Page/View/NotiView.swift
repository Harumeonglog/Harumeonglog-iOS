//
//  NotificationTableView.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import UIKit

class NotiView: UIView {
    
    public let navigationBar = CustomNavigationBar()
    
    public lazy var toInvitationButton = UIButton().then {
        $0.backgroundColor = .brown02
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private lazy var toInvitationLabel = UILabel().then {
        $0.textColor = .brown00
    }
    
    private lazy var toInvitationImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .rightBrownArrow
    }
    
    public lazy var notificationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 56, height: 30)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 23
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .background
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.bouncesHorizontally = false
        
        cv.register(NotiCollectionViewCell.self,
                    forCellWithReuseIdentifier: NotiCollectionViewCell.identifier)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(invitationCount: Int?) {
        let label = toInvitationLabel
        if let count = invitationCount {
            if count > 0 {
                label.text = "초대요청 +\(count)"
            } else {
                label.text = "초대요청이 없습니다."
            }
        } else {
            label.text = "초대요청을 불러오는 데에 실패했습니다."
        }
    }
    
    public func setConstraints() {
        setNavigationBarConstraints()
        setToInvitationButtonConstraints()
        setNotificationCollectionViewConstraints()
    }
    
    private func setNavigationBarConstraints() {
        self.addSubview(navigationBar)
        navigationBar.configureTitle(title: "알림")
        
        self.navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setToInvitationButtonConstraints() {
        self.addSubview(toInvitationButton)
        toInvitationButton.addSubview(toInvitationLabel)
        toInvitationButton.addSubview(toInvitationImageView)
        
        toInvitationButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(22)
            make.top.equalTo(navigationBar.snp.bottom).offset(33)
            make.height.equalTo(40)
        }
        
        toInvitationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }
        
        toInvitationImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(7)
        }
    }
    
    private func setNotificationCollectionViewConstraints() {
        self.addSubview(notificationCollectionView)
        
        notificationCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28)
            make.top.equalTo(toInvitationButton.snp.bottom).offset(30)
            make.bottom.equalToSuperview()
        }
    }
    
}

import SwiftUI
#Preview {
    NotiViewController()
}
