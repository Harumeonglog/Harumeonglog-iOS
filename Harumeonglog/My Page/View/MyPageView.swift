//
//  MyPageView.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/18/25.
//

import UIKit
import Kingfisher

class MyPageView: UIView {
    
    private let labelLeading: CGFloat = 38
    private let leadingTrailingPadding: CGFloat = 28
    

    public lazy var goNotification = UIButton().then {
        $0.setImage(.alarmButton, for: .normal)
    }
    private lazy var myProfileFrame = UIView()
    private lazy var myProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 40
        $0.backgroundColor = .gray03
        $0.clipsToBounds = true
    }
    private lazy var myProfileNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20)
    }
    public lazy var goEditProileButton = goToDetailButton()
    
    private lazy var myActiveLabel = commonLabel(text: "내 활동")
    private lazy var myActiveStack = UIStackView().then { $0.axis = .horizontal }
    private lazy var divider1 = UIView().then { $0.backgroundColor = .brown01 }
    private lazy var divider2 = UIView().then { $0.backgroundColor = .brown01 }
    public lazy var myPostButton = UIImageView().then { $0.image = .myPost; $0.contentMode = .scaleAspectFill }
    public lazy var likedPostButton = UIImageView().then { $0.image = .likedPost; $0.contentMode = .scaleAspectFill }
    public lazy var myCommentButton = UIImageView().then { $0.image = .myComment; $0.contentMode = .scaleAspectFill }
    
    private lazy var myPetsLabel = commonLabel(text: "반려견 목록")
    public lazy var goToPetListButton = goToDetailButton()
    public lazy var petListPreviewTable = UITableView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .brown02
    }
    
    private lazy var helpLabel = commonLabel(text: "도움")
    private lazy var sendQueryLabel = querysLabel(text: "문의하기")
    private lazy var privacyPolicyLabel = querysLabel(text: "개인정보 처리방침")
    private lazy var termsOfServiceLabel = querysLabel(text: "서비스 이용약관")
    private lazy var notificationLabel = querysLabel(text: "알림이동")
    public lazy var sendQueryButton = goToDetailButton()
    public lazy var privacyPolicyButton = goToDetailButton()
    public lazy var termsOfServiceButton = goToDetailButton()
    //public lazy var goNotification = goToDetailButton()
    public lazy var revokeButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.gray01, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
    }
    public lazy var logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.logout, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        
        $0.setImage(.logout, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    public func setConstraints() {
        setProfileConstraints()
        setActiveConstraints()
        setPuppyListPreviewConstraints()
        setHelpConstraints()
    }
    
    public func configure(_ userInfo: UserInfo) {
        myProfileNameLabel.text = userInfo.nickname ?? ""
        if let urlString = userInfo.image {
            myProfileImageView.kf.setImage(with: URL(string: "https://harumeonglog-s3.s3.ap-northeast-2.amazonaws.com/" + urlString))
        }
    }
    
    private func setProfileConstraints() {
        self.addSubview(myProfileFrame)
        myProfileFrame.addSubview(myProfileImageView)
        myProfileFrame.addSubview(myProfileNameLabel)
        myProfileFrame.addSubview(goEditProileButton)
        
        myProfileFrame.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
        }
        
        myProfileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.leading.equalToSuperview()
        }
        
        myProfileNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(myProfileImageView.snp.trailing).offset(20)
        }
        
        goEditProileButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(44)
        }
    }
    
    private func setActiveConstraints() {
        self.addSubview(myActiveLabel)
        self.addSubview(myActiveStack)
        
        myActiveLabel.snp.makeConstraints { make in
            make.top.equalTo(myProfileFrame.snp.bottom).offset(34)
            make.leading.equalToSuperview().inset(labelLeading)
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let myStackWidth: CGFloat = screenWidth - 2 * leadingTrailingPadding
        let myStackHeight: CGFloat = myStackWidth * (80.0/346.0)
        
        let buttonWidth = (myStackWidth - 2) / 3
        
        myActiveStack.clipsToBounds = true
        myActiveStack.layer.cornerRadius = myStackHeight / 4
        myActiveStack.backgroundColor = .brown02
        
        myActiveStack.snp.makeConstraints { make in
            make.top.equalTo(myActiveLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.height.equalTo(myStackHeight)
        }
        
        let buttons = [myPostButton, likedPostButton, myCommentButton]
        let dividers = [divider1, divider2]
        
        myActiveStack.addArrangedSubview(myPostButton)
        myActiveStack.addArrangedSubview(divider1)
        myActiveStack.addArrangedSubview(likedPostButton)
        myActiveStack.addArrangedSubview(divider2)
        myActiveStack.addArrangedSubview(myCommentButton)
        
        for divider in dividers {
            divider.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.top.bottom.equalTo(myActiveStack).inset(myStackHeight/6)
                make.centerY.equalToSuperview()
            }
        }
        
        for button in buttons {
            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
            }
        }
        
    }
    
    private func setPuppyListPreviewConstraints() {
        self.addSubview(myPetsLabel)
        self.addSubview(goToPetListButton)
        self.addSubview(petListPreviewTable)
        
        myPetsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(labelLeading)
            make.top.equalTo(myActiveStack.snp.bottom).offset(24)
        }
        
        goToPetListButton.snp.makeConstraints { make in
            make.centerY.equalTo(myPetsLabel)
            make.trailing.equalToSuperview().offset(-leadingTrailingPadding)
            make.height.equalTo(48)
            make.width.equalTo(48)
        }
        
        petListPreviewTable.snp.makeConstraints { make in
            make.top.equalTo(myPetsLabel.snp.bottom).offset(10)
            make.height.equalTo(150)
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
        }
    }
    
    private func setHelpConstraints() {
        self.addSubview(helpLabel)
        
        helpLabel.snp.makeConstraints { make in
            make.top.equalTo(petListPreviewTable.snp.bottom).offset(24)
            make.leading.equalTo(labelLeading)
        }
        
        self.addSubview(sendQueryLabel)
        self.addSubview(privacyPolicyLabel)
        self.addSubview(termsOfServiceLabel)
        self.addSubview(notificationLabel)
        
        sendQueryLabel.snp.makeConstraints { make in
            make.top.equalTo(helpLabel.snp.bottom).offset(24)
            make.leading.equalTo(labelLeading)
        }
        
        privacyPolicyLabel.snp.makeConstraints { make in
            make.top.equalTo(sendQueryLabel.snp.bottom).offset(12)
            make.leading.equalTo(labelLeading)
        }
        
        termsOfServiceLabel.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyLabel.snp.bottom).offset(12)
            make.leading.equalTo(labelLeading)
        }
        
        notificationLabel.snp.makeConstraints { make in
            make.top.equalTo(termsOfServiceLabel.snp.bottom).offset(12)
            make.leading.equalTo(labelLeading)
        }
        
        self.addSubview(sendQueryButton)
        self.addSubview(privacyPolicyButton)
        self.addSubview(termsOfServiceButton)
        self.addSubview(goNotification)
        self.addSubview(revokeButton)
        self.addSubview(logoutButton)
        
        sendQueryButton.snp.makeConstraints { make in
            make.centerY.equalTo(sendQueryLabel)
            make.trailing.equalToSuperview().offset(-labelLeading)
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.centerY.equalTo(privacyPolicyLabel)
            make.trailing.equalToSuperview().offset(-labelLeading)
        }
        
        termsOfServiceButton.snp.makeConstraints { make in
            make.centerY.equalTo(termsOfServiceLabel)
            make.trailing.equalToSuperview().offset(-labelLeading)
        }
        
        goNotification.snp.makeConstraints { make in
            make.centerY.equalTo(notificationLabel)
            make.trailing.equalToSuperview().offset(-labelLeading)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(40)
            make.top.equalTo(goNotification.snp.bottom).offset(20)
        }
        
        logoutButton.imageView?.snp.makeConstraints{ make in
            make.centerY.equalTo(logoutButton)
            make.trailing.equalToSuperview().inset(-30)
            make.height.equalTo(16)
        }
        
        revokeButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoutButton)
            make.centerX.equalToSuperview().offset(-50)
        }
        
    }
    
    private func commonLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = .gray01
            $0.font = .systemFont(ofSize: 14)
        }
    }
    
    private func querysLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = .gray01
            $0.font = .systemFont(ofSize: 16)
        }
    }
    
    private func goToDetailButton() -> UIButton {
        return UIButton().then {
            $0.setImage(.rightArrow, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
            // $0.imageView?.snp.makeConstraints { $0.height.width.equalTo(20) }
            $0.tintColor = .gray01
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
