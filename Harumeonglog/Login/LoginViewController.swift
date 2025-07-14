//
//  LoginViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/15/25.
//

import UIKit
import KakaoSDKUser
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    let provider = ASAuthorizationAppleIDProvider()
    
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
            kakaoLonginWithApp()
        } else { // 카톡이 설치가 안 되어 있을 때
            // 카카오 계정으로 로그인
            kakaoLoginWithAccount()
        }
    }
    
    func kakaoLonginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print("카카오 APP 로그인 에러")
                print(error)
            } else {
                guard let oauthToken = oauthToken else { return }
                AuthAPIService.login(id: oauthToken.idToken!, social: .KAKAO)
            }
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print("카카오 WEB 로그인 에러")
                print(error)
            } else {
                guard let oauthToken = oauthToken else { return }
                AuthAPIService.login(id: oauthToken.idToken!, social: .KAKAO)
            }
        }
    }
    
}

extension LoginViewController : ASAuthorizationControllerDelegate {
    
    @objc
    private func handleAppleLogin() {
        // RootViewControllerService.toBaseViewController()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email] // 사용자에게 제공받을 정보를 선택
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user // user: 처음 로그인을 하게 되면, 유저에게 주어지는 고유 식별
            let fullName = appleIDCredential.fullName   // fullName: 사용자 이름
            let email = appleIDCredential.email         // email: 사용자 메일
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(String(describing: fullName))")
            print("email: \(String(describing: email))")
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken, // identityToken: 사용자에 대한 정보를 앱에 안전히 전달하는 JWT
                let authCodeString = String(data: authorizationCode, encoding: .utf8), // authorizationCode: 앱이 서버와 상호 작용하는 데 사용하는 토큰
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
                
                AuthAPIService.login(id: identifyTokenString, social: .APPLE)
            }
        case let passwordCredential as ASPasswordCredential:
            print(passwordCredential)
            break
        default:
            break
        }
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
