//
//  BaseViewControllers.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

class MyPageViewController: UIViewController, UIGestureRecognizerDelegate, PetListViewControllerDelegate {
    
    private let myPageView = MyPageView()
    private let petListVC = PetListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPageView
        setButtonActions()
        petListVC.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        myPageView.setConstraints()
    }
    
    private func setButtonActions() {
        myPageView.goNotification.addTarget(self, action: #selector(goToNotificationSettingVC), for: .touchUpInside)
        myPageView.goEditProileButton.addTarget(self, action: #selector(handleEditProfileButtonTapped), for: .touchUpInside)
        myPageView.goToPetListButton.addTarget(self, action: #selector(handlePetLisstButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func goToNotificationSettingVC() {
        let notiVC = SetNotificationViewController()
        self.navigationController?.pushViewController(notiVC, animated: true)
    }
    
    @objc
    private func handleEditProfileButtonTapped() {
        let editVC = EditProfileViewController()
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc
    private func handlePetLisstButtonTapped() {
        self.navigationController?.pushViewController(petListVC, animated: true)
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

import SwiftUI
#Preview {
    BaseViewController()
}
