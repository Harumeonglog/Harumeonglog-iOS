//
//  File.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/25/25.
//

import UIKit

class RootViewControllerService {
    private static let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    private static let loginViewController = LoginViewController()
    private static let baseViewController = BaseViewController()
    private static let policyAgreementView = PolicyAgreementViewController()
    
    static func toBaseViewController() {
        baseViewController.selectedIndex = 0
        sceneDelegate?.changeRootViewController(baseViewController, animated: false)
    }
    
    static func toLoginViewController() {
        sceneDelegate?.changeRootViewController(loginViewController, animated: false)
    }
    
    static func toPolicyAgreementViewController() {
        sceneDelegate?.changeRootViewController(policyAgreementView, animated: false)
    }
    
}
