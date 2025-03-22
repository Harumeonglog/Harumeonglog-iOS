//
//  EditProfileViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/19/25.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    private let editProfileView = EditProfileView()
    
    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editProfileView
        self.picker.delegate = self
        hideKeyboardWhenTappedAround()
        setActions()
    }

    override func viewDidLayoutSubviews() {
        editProfileView.setConstraints()
    }
    
    private func setActions() {
        editProfileView.cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        editProfileView.cameraButton.addTarget(self, action: #selector(textFieldEditing), for: .valueChanged)
        editProfileView.navigationBar.rightButton.addTarget(self, action: #selector(completionButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func cameraButtonPressed() {
        picker.sourceType = .camera // 카메라를 통해 가져온다
            picker.allowsEditing = false // 수정 true면 허용
            picker.cameraDevice = .rear // 후면 카메라
            picker.cameraCaptureMode = .photo //사진 (영상X)
            
            present(picker, animated: true, completion: nil)
    }
    
    @objc
    private func textFieldEditing() {
        
    }
    
    @objc
    private func completionButtonPressed() {
        
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            editProfileView.setProfileImage(image)
        }
        
        dismiss(animated: true)
    }

}

import SwiftUI
#Preview {
    EditProfileViewController()
}
