//
//  NotificationSettingView.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/20/25.
//

import UIKit

class DetailSettingView: UIView {
    
    public let navigationBar = CustomNavigationBar()
    
    private let notificationLabel = UILabel().then {
        $0.text = "설정"
        $0.textColor = .gray01
        $0.font = .systemFont(ofSize: 16)
    }
    
    private let stackBackground = UIView().then {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }
    
    private let notificationStack = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .white
    }
    
    public let morningNotification = NotificatonSettingCell()
    public let todoNotification = NotificatonSettingCell()
    public let commentNotification = NotificatonSettingCell()
    public let likeNotification = NotificatonSettingCell()
    
    public func configure() {
        setCustomNavigationBarConstraints()
        setConstraints()
    }
    
    private func setCustomNavigationBarConstraints() {
        navigationBar.configureTitle(title: "알림 설정")
        self.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setConstraints() {
        self.addSubview(notificationLabel)
        self.addSubview(stackBackground)
        stackBackground.addSubview(notificationStack)
        
        notificationLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(34)
            make.top.equalTo(navigationBar.snp.bottom).offset(39)
        }
        
        stackBackground.snp.makeConstraints { make in
            make.top.equalTo(notificationLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(28)
            make.height.equalTo(260)
        }
        
        notificationStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        notificationStack.addArrangedSubview(morningNotification)
        notificationStack.addArrangedSubview(todoNotification)
        notificationStack.addArrangedSubview(commentNotification)
        notificationStack.addArrangedSubview(likeNotification)
        
        morningNotification.configure(main: "아침 알림", sub: "아침 7시에 하루 일정에 대한 알림을 보내줍니다.")
        todoNotification.configure(main: "일정 알림", sub: "일정에 설정한 알림을 보내줍니다.")
        commentNotification.configure(main: "게시글 댓글 알림", sub: "게시글에 댓글이 달릴 때 알림을 보내줍니다.")
        likeNotification.configure(main: "게시글 좋아요 알림", sub: "게시글에 좋아요가 달릴 때 알림을 보내줍니다.")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NotificatonSettingCell: UIView {
    
    private let textContainer: UIView = UIView()
    
    private let mainTitle = UILabel().then {
        $0.textColor = .gray00
        $0.font = .body
    }
    
    private let subTitle = UILabel().then {
        $0.textColor = .gray02
        $0.font = .description
    }
    
    public let switchView = UISwitch().then {
        $0.onTintColor = .blue01
    }
    
    public func configure(main: String, sub: String) {
        mainTitle.text = main
        subTitle.text = sub
    }
    
    private func setConstraints() {
        self.addSubview(switchView)
        self.addSubview(textContainer)
        textContainer.addSubview(mainTitle)
        textContainer.addSubview(subTitle)
        
        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-2)
        }
        
        textContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.height.greaterThanOrEqualTo(20)
            make.centerY.equalToSuperview()
        }
        
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        self.snp.makeConstraints { make in
            make.height.equalTo(57)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

import SwiftUI
#Preview {
    DetailSettingViewController()
}
