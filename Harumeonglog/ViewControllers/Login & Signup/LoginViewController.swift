//
//  LoginViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/15/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let registPetViewController = PetRegistrationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        registPetViewController.modalPresentationStyle = .overFullScreen
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
        present(registPetViewController, animated: false)
    }
    
    @objc
    private func handleKakaologin() {
        present(registPetViewController, animated: false)
    }
    
}
