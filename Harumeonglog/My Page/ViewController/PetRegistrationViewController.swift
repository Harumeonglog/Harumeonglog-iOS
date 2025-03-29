//
//  PuppyRegistrationViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/17/25.
//

import UIKit

class PetRegistrationViewController: UIViewController {
    
    private let petRegistrationView = PetRegistrationView()
    private let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = petRegistrationView
        hideKeyboardWhenTappedAround()
        setButtonActions()
    }
    
    override func viewDidLayoutSubviews() {
        petRegistrationView.setConstraints()
    }
    
    private func setButtonActions() {
        setNavigationBarButtonAction()
        setDogSizeButtonActions()
        setTextFieldAction()
        setPetRegistrationButtonAction()
        setPetGenderButtonAction()
    }
    
    private func isAllInfosFilled() {
        if petRegistrationView.petNameTextField.text != "",
           petRegistrationView.dogTypeTextField.text != "",
           petRegistrationView.selectedDogSize != nil,
           petRegistrationView.selectedDogGender != nil
        {
            petRegistrationView.registButton.available()
        }
    }
    
}

// 네비게이션 바
extension PetRegistrationViewController {
    private func setNavigationBarButtonAction() {
        petRegistrationView.navigationBar.leftArrowButton.addTarget(self, action: #selector(handleNavigationBarLeftButton), for: .touchUpInside)
    }
    
    @objc
    private func handleNavigationBarLeftButton() {
        dismiss(animated: false)
    }
}

// 반려견 크기 선택
extension PetRegistrationViewController {
    
    private func setDogSizeButtonActions() {
        for btn in [
            petRegistrationView.smallPetSizeButton,
            petRegistrationView.middlePetSizeButton,
            petRegistrationView.bigPetSizeButton,
        ] {
            btn.addTarget(self, action: #selector(selectDogSize), for: .touchUpInside)
        }
    }
    
    @objc
    private func selectDogSize(_ sender: DogSizeButton) {
        for btn in [
            petRegistrationView.smallPetSizeButton,
            petRegistrationView.middlePetSizeButton,
            petRegistrationView.bigPetSizeButton,
        ] {
            if btn == sender {
                btn.setSelectedImage()
                petRegistrationView.selectedDogSize = btn.size
            } else {
                btn.setUnselectedImage()
            }
        }
        isAllInfosFilled()
    }
    
}

// 텍스트 필드
extension PetRegistrationViewController {
    
    private func setTextFieldAction() {
        petRegistrationView.petNameTextField
            .addTarget(self, action: #selector(handlTextFieldAllEditingEvents), for: .allEditingEvents)
        petRegistrationView.dogTypeTextField
            .addTarget(self, action: #selector(handlTextFieldAllEditingEvents), for: .allEditingEvents)
    }
    
    @objc
    private func handlTextFieldAllEditingEvents() {
        isAllInfosFilled()
    }
    
}

// 반려견 성별 선택
extension PetRegistrationViewController {
    
    private func setPetGenderButtonAction() {
        petRegistrationView.dogGenderSelectButton.addTarget(self, action: #selector(handlePetGenderButtonTap), for: .touchUpInside)
        
        let firstAction = UIAlertAction(title: "중성", style: .default, handler: {_ in
            self.petRegistrationView.selectDogGender(.neutered)
            self.isAllInfosFilled()
        })
        let secondAction = UIAlertAction(title: "수컷", style: .default, handler: {_ in
            self.petRegistrationView.selectDogGender(.male)
            self.isAllInfosFilled()
        })
        let thirdAction = UIAlertAction(title: "암컷", style: .default, handler: {_ in
            self.petRegistrationView.selectDogGender(.female)
            self.isAllInfosFilled()
        })
        actionSheet.addAction(firstAction)
        actionSheet.addAction(secondAction)
        actionSheet.addAction(thirdAction)
    }
    
    @objc
    private func handlePetGenderButtonTap() {
        self.present(actionSheet, animated: true, completion: nil)
    }
}
// 등록하기
extension PetRegistrationViewController {
    
    private func setPetRegistrationButtonAction() {
        self.petRegistrationView.registButton.addTarget(self, action: #selector(handleRegistrationButtonTap), for: .touchUpInside)
    }
    
    @objc
    private func handleRegistrationButtonTap() {
        RootViewControllerService.toBaseViewController()
    }
}

import SwiftUI
#Preview {
    PetRegistrationViewController()
}
