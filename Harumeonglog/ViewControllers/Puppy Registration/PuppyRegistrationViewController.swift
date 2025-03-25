//
//  PuppyRegistrationViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/17/25.
//

import UIKit

class PuppyRegistrationViewController: UIViewController {
    
    private let puppyRegistrationView = PuppyRegistrationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = puppyRegistrationView
        hideKeyboardWhenTappedAround()
        setButtonActions()
    }
    
    override func viewDidLayoutSubviews() {
        puppyRegistrationView.setConstraints()
    }
    
    private func setButtonActions() {
        puppyRegistrationView.navigationBar.leftArrowButton.addTarget(self, action: #selector(handleLeftButtonTap), for: .touchUpInside)
        for btn in [
            puppyRegistrationView.smallPuppySizeButton,
            puppyRegistrationView.middlePuppySizeButton,
            puppyRegistrationView.bigPuppySizeButton,
        ] {
            btn.addTarget(self, action: #selector(selectDogSize), for: .touchUpInside)
        }
    }
    
    @objc
    private func handleLeftButtonTap() {
        dismiss(animated: false)
    }
    
    @objc
    private func selectDogSize(_ sender: PuppySizeButton) {
        for btn in [
            puppyRegistrationView.smallPuppySizeButton,
            puppyRegistrationView.middlePuppySizeButton,
            puppyRegistrationView.bigPuppySizeButton,
        ] {
            if btn == sender {
                btn.setSelectedImage()
            } else {
                btn.setUnselectedImage()
            }
        }
    }
    
}

import SwiftUI
#Preview {
    PuppyRegistrationViewController()
}
