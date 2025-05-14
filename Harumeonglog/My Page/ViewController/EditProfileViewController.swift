//
//  EditProfileViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/19/25.
//

import UIKit
import Alamofire

class EditProfileViewController: UIViewController {
    
    private let editProfileView = EditProfileView()
    private let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    private var userInfo: InfoParameters?
    private var selectedImage: UIImage?
    private var imageKey: String?
    
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
    
    public func configure(userInfo: InfoParameters) {
        self.userInfo = userInfo
        editProfileView.nicknameTextField.text = userInfo.nickname
        if let url = userInfo.image {
            editProfileView.setPrifileImageByURL(URL(string: url)!)
        }
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
        guard let nickname = editProfileView.nicknameTextField.text, !nickname.isEmpty else { return }
        
    }
    
    @objc
    private func handleCameraButtonTap() {
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc
    private func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.editProfileView.setProfileImage(image)
            self.selectedImage = image  // 선택된 이미지 저장
        }
        dismiss(animated: true)
    }
    
    
    
    private func updateProfile(imageKey: String, nickname: String) {
        MemberAPIService.patchInfo(
            param: InfoParameters(image: imageKey, nickname: nickname)
        ) { [weak self] code in
            guard let self = self else { return }
            switch code {
            case .COMMON200:
                
                self.navigationController?.popViewController(animated: true)
            case .AUTH401:
                RootViewControllerService.toLoginViewController()
            case .ERROR500:
                // 서버 에러 발생
                break
            default:
                break
            }
        }
    }
}
