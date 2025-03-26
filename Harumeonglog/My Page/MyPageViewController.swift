//
//  BaseViewControllers.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private let myPageView = MyPageView()
    private let editVC = EditProfileViewController()
    private let petListVC = PetListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPageView
        setButtonActions()
    }
    
    override func viewDidLayoutSubviews() {
        myPageView.setConstraints()
    }
    
    private func setButtonActions() {
        myPageView.goEditProileButton.addTarget(self, action: #selector(handleEditProfileButtonTapped), for: .touchUpInside)
        myPageView.goToPetListButton.addTarget(self, action: #selector(handlePetLisstButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func handleEditProfileButtonTapped() {
        editVC.modalPresentationStyle = .overFullScreen
        present(editVC, animated: false)
    }
    
    @objc
    private func handlePetLisstButtonTapped() {
        petListVC.modalPresentationStyle = .overFullScreen
        present(petListVC, animated: false)
    }
    
}

import SwiftUI
#Preview {
    MyPageViewController()
}
