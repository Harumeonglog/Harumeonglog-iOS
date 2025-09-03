//
//  LoginView.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/15/25.
//

import UIKit
import SnapKit
import Then

class LoginView: UIView {
    
    private lazy var appLogo = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
        $0.image = .appLogo 
    }
    
    public lazy var kakaoLoginButton = SocialLoginButton()
    public lazy var appleLoginButton = SocialLoginButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(appLogo)
        self.addSubview(kakaoLoginButton)
        self.addSubview(appleLoginButton)
        
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(183)
            make.height.width.equalTo(180)
        }
        
        kakaoLoginButton.configure(title: "카카오로 시작하기", logog: .kakaoLogo, color: .kakaoYellow)
        appleLoginButton.configure(title: "Apple로 계속하기", logog: .appleLogo, color: .white)
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-23)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-168)
        }
    }
    
}
