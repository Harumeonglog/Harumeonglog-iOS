//
//  EditProfileViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/19/25.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    private let editProfileView = EditProfileView()
    private let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editProfileView
        picker.delegate = self
        hideKeyboardWhenTappedAround()
        setActions()
    }
    
    override func viewDidLayoutSubviews() {
        editProfileView.setConstraints()
    }
    
    private func setActions() {
        editProfileView.navigationBar.leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        editProfileView.navigationBar.rightButton.addTarget(self, action: #selector(completionButtonPressed), for: .touchUpInside)
        editProfileView.nicknameTextField.addTarget(self, action: #selector(textFieldEditing), for: .valueChanged)
        editProfileView.cameraButton.addTarget(self, action: #selector(handleCameraButtonTap), for: .touchUpInside)
        
        let firstAction = UIAlertAction(title: "카메라", style: .default, handler: {_ in
            self.showCameraVC()})
        let secondAction = UIAlertAction(title: "이미지 불러오기", style: .default, handler: {_ in
            self.showPhotoLibrary()})
        actionSheet.addAction(firstAction)
        actionSheet.addAction(secondAction)
    }
    
    @objc
    private func showCameraVC() {
        picker.sourceType = .camera // 카메라를 통해 가져온다
        picker.allowsEditing = false // 수정 true면 허용
        picker.cameraDevice = .rear // 후면 카메라
        picker.cameraCaptureMode = .photo //사진 (영상X)
        present(picker, animated: true, completion: nil)
    }
    
    @objc
    private func showPhotoLibrary() {
        picker.sourceType = .photoLibrary // 카메라를 통해 가져온다
        picker.allowsEditing = false // 수정 true면 허용
        present(picker, animated: true, completion: nil)
    }
    
    @objc
    private func textFieldEditing() {
        
    }
    
    @objc
    private func completionButtonPressed() {
        // API 연동
    }
    
    @objc
    private func handleCameraButtonTap() {
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc
    private func dismissViewController() {
        dismiss(animated: false)
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.editProfileView.setProfileImage(image)
        }
        dismiss(animated: true)
    }
    
}

import SwiftUI
#Preview {
    EditProfileViewController()
}
