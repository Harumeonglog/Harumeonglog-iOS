//
//  PuppyRegistrationViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/17/25.
//

import UIKit

class EditOrRegistPetViewController: UIViewController {
    
    private var pet: Pet?
    private let editOrRegistPetView = EditOrRegistPetView()
    private let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editOrRegistPetView
        hideKeyboardWhenTappedAround()
        setButtonActions()
    }
    
    override func viewDidLayoutSubviews() {
        editOrRegistPetView.setConstraints()
    }
    
    private func setButtonActions() {
        setNavigationBarButtonAction()
        setDogSizeButtonActions()
        setTextFieldAction()
        setPetRegistrationButtonAction()
        setPetGenderButtonAction()
        setPetBirthdayButtonAction()
    }
    
    private func isAllInfosFilled() {
        if editOrRegistPetView.petNameTextField.text != "",
           editOrRegistPetView.dogTypeTextField.text != "",
           editOrRegistPetView.selectedDogSize != nil,
           editOrRegistPetView.selectedDogGender != nil,
           self.editOrRegistPetView.birthday != nil
        {
            editOrRegistPetView.confirmButton.available()
        }
    }
    
    public func configure(pet: Pet) {
        self.pet = pet
        self.editOrRegistPetView.configure(pet: pet)
    }
}

// 네비게이션 바
extension EditOrRegistPetViewController {
    private func setNavigationBarButtonAction() {
        editOrRegistPetView.navigationBar.leftArrowButton.addTarget(self, action: #selector(handleNavigationBarLeftButton), for: .touchUpInside)
    }
    
    @objc
    private func handleNavigationBarLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// 반려견 크기 선택
extension EditOrRegistPetViewController {
    private func setDogSizeButtonActions() {
        for btn in [
            editOrRegistPetView.smallPetSizeButton,
            editOrRegistPetView.middlePetSizeButton,
            editOrRegistPetView.bigPetSizeButton,
        ] {
            btn.addTarget(self, action: #selector(selectDogSize), for: .touchUpInside)
        }
    }
    
    @objc
    private func selectDogSize(_ sender: DogSizeButton) {
        for btn in [
            editOrRegistPetView.smallPetSizeButton,
            editOrRegistPetView.middlePetSizeButton,
            editOrRegistPetView.bigPetSizeButton,
        ] {
            if btn == sender {
                btn.setSelectedImage()
                editOrRegistPetView.selectedDogSize = btn.size
            } else {
                btn.setUnselectedImage()
            }
        }
        isAllInfosFilled()
    }
}

// 텍스트 필드
extension EditOrRegistPetViewController {
    private func setTextFieldAction() {
        editOrRegistPetView.petNameTextField
            .addTarget(self, action: #selector(handlTextFieldAllEditingEvents), for: .allEditingEvents)
        editOrRegistPetView.dogTypeTextField
            .addTarget(self, action: #selector(handlTextFieldAllEditingEvents), for: .allEditingEvents)
    }
    
    @objc
    private func handlTextFieldAllEditingEvents() {
        isAllInfosFilled()
    }
}

// 반려견 성별 선택
extension EditOrRegistPetViewController {
    private func setPetGenderButtonAction() {
        editOrRegistPetView.dogGenderSelectButton.addTarget(self, action: #selector(handlePetGenderButtonTap), for: .touchUpInside)
        let firstAction = UIAlertAction(title: "중성", style: .default, handler: {_ in
            self.editOrRegistPetView.selectDogGender(.NEUTER)
            self.isAllInfosFilled() })
        let secondAction = UIAlertAction(title: "수컷", style: .default, handler: {_ in
            self.editOrRegistPetView.selectDogGender(.MALE)
            self.isAllInfosFilled() })
        let thirdAction = UIAlertAction(title: "암컷", style: .default, handler: {_ in
            self.editOrRegistPetView.selectDogGender(.FEMALE)
            self.isAllInfosFilled() })
        actionSheet.addAction(firstAction)
        actionSheet.addAction(secondAction)
        actionSheet.addAction(thirdAction)
    }
    
    @objc
    private func handlePetGenderButtonTap() {
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension EditOrRegistPetViewController {
    private func setPetBirthdayButtonAction() {
        self.editOrRegistPetView.birthdateSelectButton.addTarget(self, action: #selector(handlePetBirthdayuttonTap), for: .touchUpInside)
    }
    
    @objc
    private func handlePetBirthdayuttonTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let ok = UIAlertAction(title: "선택 완료", style: .cancel, handler: { _ in
            let birthday = datePicker.date
            self.editOrRegistPetView.birthday = birthday
            let formattedDate = dateFormatter.string(from: birthday)
            self.editOrRegistPetView.birthdateSelectButton.setTitle(formattedDate, for: .normal)
            self.editOrRegistPetView.confirmButton.available()
        })
        alert.addAction(ok)
        
        let vc = UIViewController()
        vc.view = datePicker
        
        alert.setValue(vc, forKey: "contentViewController")
        present(alert, animated: true)
    }
}

// 등록하기 or 수정하기
extension EditOrRegistPetViewController {
    private func setPetRegistrationButtonAction() {
        self.editOrRegistPetView.confirmButton.addTarget(self, action: #selector(handleRegistrationButtonTap), for: .touchUpInside)
    }
    
    @objc
    private func handleRegistrationButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

import SwiftUI
#Preview {
    EditOrRegistPetViewController()
}
