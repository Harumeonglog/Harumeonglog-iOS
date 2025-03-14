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
    }
    
}
