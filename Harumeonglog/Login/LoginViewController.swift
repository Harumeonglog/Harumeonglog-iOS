//
//  LoginViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/15/25.
//

import UIKit
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        setButtonActions()
    }
    
}

extension LoginViewController {
    
    private func setButtonActions() {
        self.loginView.appleLoginButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        self.loginView.kakaoLoginButton.addTarget(self, action: #selector(handleKakaologin), for: .touchUpInside)
    }
        
    @objc
    private func handleKakaologin() {
        KakaoLogin()
    }
    
    func KakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 앱으로 로그인 인증
            print("111")
            kakaoLonginWithApp()
        } else { // 카톡이 설치가 안 되어 있을 때
            // 카카오 계정으로 로그인
            kakaoLoginWithAccount()
        }
    }
    
    func kakaoLonginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                // print("카카오 APP 로그인 에러")
                print(error)
            } else {
                guard let oauthToken = oauthToken else { return }
                print(oauthToken)
            }
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                // print("카카오 WEB 로그인 에러")
                print(error)
            } else {
                guard let oauthToken = oauthToken else { return }
                print(oauthToken)
            }
        }
    }
    
    func kakaoLogin(oauthToken: String) {
        
    }
    
    @objc
    private func handleAppleLogin() {
        RootViewControllerService.toBaseViewController()
    }
    
}
