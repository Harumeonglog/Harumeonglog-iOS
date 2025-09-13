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
        $0.setImage(.rightArrow , for: .normal)
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
        $0.font = .headline
    }
    
    public lazy var goEditProileButton = goToDetailButton()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var myActiveLabel = commonLabel(text: "내 활동")
    private lazy var myActiveStack = UIStackView().then { $0.axis = .horizontal }
    private lazy var divider1 = UIView().then { $0.backgroundColor = .brown01 }
    private lazy var divider2 = UIView().then { $0.backgroundColor = .brown01 }
    public lazy var myPostButton = UIButton().then {
        $0.setImage(.myPost, for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    public lazy var likedPostButton = UIButton().then {
        $0.setImage(.likedPost, for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    public lazy var myCommentButton = UIButton().then {
        $0.setImage(.myComment, for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var myPetsLabel = commonLabel(text: "반려견 목록")
    public lazy var goToPetListButton = goToDetailButton()
    public lazy var previewPetListTableView = UITableView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .brown02
        $0.allowsSelection = false
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
        $0.titleLabel?.font = .body
    }
    public lazy var logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.logout, for: .normal)
        $0.titleLabel?.font = .body
        
        $0.setImage(.logout, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    public func setConstraints() {
        setProfileConstraints()
        setScrollContainer()
        setActiveConstraints()
        setPuppyListPreviewConstraints()
        setHelpConstraints()
    }
    
    public func configure(_ userInfo: UserInfo) {
        myProfileNameLabel.text = userInfo.nickname ?? ""
        if let urlString = userInfo.image {
            myProfileImageView.kf.setImage(with: URL(string: urlString))
        }
    }
    
    private func setScrollContainer() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    private func setProfileConstraints() {
        contentView.addSubview(myProfileFrame)
        myProfileFrame.addSubview(myProfileImageView)
        myProfileFrame.addSubview(myProfileNameLabel)
        myProfileFrame.addSubview(goEditProileButton)
        
        myProfileFrame.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.top.equalToSuperview().offset(40)
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
        contentView.addSubview(myActiveLabel)
        contentView.addSubview(myActiveStack)
        
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
                make.top.bottom.equalTo(myActiveStack).inset(myStackHeight/6).priority(.high)
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
        contentView.addSubview(myPetsLabel)
        contentView.addSubview(goToPetListButton)
        contentView.addSubview(previewPetListTableView)

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

        previewPetListTableView.snp.makeConstraints { make in
            make.top.equalTo(myPetsLabel.snp.bottom).offset(10)
            make.height.equalTo(150)
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
        }
    }
    
    private func setHelpConstraints() {
        contentView.addSubview(helpLabel)

        helpLabel.snp.makeConstraints { make in
            make.top.equalTo(previewPetListTableView.snp.bottom).offset(24)
            make.leading.equalTo(labelLeading)
        }

        contentView.addSubview(sendQueryLabel)
        contentView.addSubview(privacyPolicyLabel)
        contentView.addSubview(termsOfServiceLabel)
        contentView.addSubview(notificationLabel)

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

        contentView.addSubview(sendQueryButton)
        contentView.addSubview(privacyPolicyButton)
        contentView.addSubview(termsOfServiceButton)
        contentView.addSubview(goNotification)
        contentView.addSubview(revokeButton)
        contentView.addSubview(logoutButton)

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
            make.top.equalTo(goNotification.snp.bottom).offset(50)
        }

        logoutButton.imageView?.snp.makeConstraints { make in
            make.centerY.equalTo(logoutButton)
            make.trailing.equalToSuperview().inset(-30)
            make.height.equalTo(14)
        }

        revokeButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoutButton)
            make.centerX.equalToSuperview().offset(-50)
        }

        // IMPORTANT: Define scrollable content height
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(logoutButton.snp.bottom).offset(20)
        }
    }
    
    private func commonLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = .gray01
            $0.font = .body
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
        previewPetListTableView.register(PreviewPetCell.self, forCellReuseIdentifier: PreviewPetCell.identifier)
        previewPetListTableView.rowHeight = 50
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
