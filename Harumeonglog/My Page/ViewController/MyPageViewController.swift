//
//  BaseViewControllers.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private let myPageView = MyPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPageView
        setButtonActions()
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
        notiVC.modalPresentationStyle = .overFullScreen
        present(notiVC, animated: false)
    }
    
    @objc
    private func handleEditProfileButtonTapped() {
        let editVC = EditProfileViewController()
        editVC.modalPresentationStyle = .overFullScreen
        present(editVC, animated: false)
    }
    
    @objc
    private func handlePetLisstButtonTapped() {
        let petListVC = PetListViewController()
        petListVC.modalPresentationStyle = .overFullScreen
        present(petListVC, animated: false)
    }
    
}

import SwiftUI
#Preview {
    MyPageViewController()
}
