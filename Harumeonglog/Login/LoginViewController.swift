//
//  LoginViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/15/25.
//

import UIKit

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
    private func handleAppleLogin() {
        RootViewControllerService.toBaseViewController()
    }
    
    @objc
    private func handleKakaologin() {
        RootViewControllerService.toBaseViewController()
    }
    
}
