//
//  EditProfileView.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/19/25.
//

import UIKit

class EditProfileView: UIView {
    
    private let leadingTrailingPadding: CGFloat = 38
    public lazy var navigationBar = CustomNavigationBar()
    
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "defaultImage")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 80
        $0.clipsToBounds = true
        $0.backgroundColor = .gray01
    }
    
    public lazy var cameraButton = UIButton().then {
        $0.setImage(.camera, for: .normal)
    }
    
    private lazy var nicknameLabel = commonLabel(text: "닉네임")
    public lazy var nicknameTextField = UITextField.commonTextField()
    
    private lazy var birthdayLabel = commonLabel(text: "생년월일")
    public lazy var birthdayButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitleColor(.gray03, for: .normal)
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.brown02.cgColor
    }
    
    public func setProfileImage(_ image: UIImage) {
        profileImageView.image = image
    }
    
    public func setPrifileImageByURL(_ url: URL) {
        profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
    }
    
    public func setConstraints() {
        setCustomNavigationBarConstraints()
        navigationBar.configureRightButton(text: "완료")
        setProfileConstraints()
        setNicknameConstraints()
    }
    
    private func setCustomNavigationBarConstraints() {
        navigationBar.configureTitle(title: "내정보 수정")
        
        self.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setProfileConstraints() {
        self.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(160)
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom).offset(40)
        }
        
        self.addSubview(cameraButton)
        
        cameraButton.snp.makeConstraints { make in
            make.center.equalTo(profileImageView.snp.center).offset(55)
            make.width.height.equalTo(59)
        }
        
        cameraButton.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
    
    private func setNicknameConstraints() {
        self.addSubview(nicknameLabel)
        self.addSubview(nicknameTextField)
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(55)
            make.leading.equalToSuperview().offset(47+25)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    }
    
    private func commonLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.font = .body
            $0.textColor = .gray02
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
