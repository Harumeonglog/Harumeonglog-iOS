//
//  PuppyRegistrationViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/17/25.
//

import UIKit

class EditOrRegistPetViewController: UIViewController {
    
    private var petListViewModel: PetListViewModel?
    private var pet: Pet?
    private var mode: RegistOrEditMode?
    private let editOrRegistPetView = EditOrRegistPetView()
    private let actionSheetForGender = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    private let actionSheetForPhoto = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    private let datePicker = UIDatePicker()
    
    // 이미지 관련 프로퍼티
    private var selectedImage: UIImage?
    private var imageKey: String?
    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()
    
    func configure(pet: Pet?, petListViewModel: PetListViewModel?, mode: RegistOrEditMode ) {
        self.petListViewModel = petListViewModel
        self.pet = pet
        self.mode = mode
        guard let pet = pet else { return }
        self.editOrRegistPetView.configure(pet: pet, mode: mode)
        print(pet.petId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editOrRegistPetView
        picker.delegate = self
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
        setImageButtonAction()
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
        actionSheetForGender.addAction(firstAction)
        actionSheetForGender.addAction(secondAction)
        actionSheetForGender.addAction(thirdAction)
    }
    
    @objc
    private func handlePetGenderButtonTap() {
        self.present(actionSheetForGender, animated: true, completion: nil)
    }
}

// 생일 선택
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
        self.editOrRegistPetView.confirmButton.addTarget(self, action: #selector(completionButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func handleRegistrationButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditOrRegistPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setImageButtonAction() {
        editOrRegistPetView.cameraButton.addTarget(self, action: #selector(handleCameraButtonTap), for: .touchUpInside)
        
        let firstAction = UIAlertAction(title: "카메라", style: .default, handler: {_ in
            self.showCameraVC()})
        let secondAction = UIAlertAction(title: "이미지 불러오기", style: .default, handler: {_ in
            self.showPhotoLibrary()})
        actionSheetForPhoto.addAction(firstAction)
        actionSheetForPhoto.addAction(secondAction)
    }
    
    @objc
    private func handleCameraButtonTap() {
        self.present(actionSheetForPhoto, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.editOrRegistPetView.setProfileImage(image)
            self.selectedImage = image  // 선택된 이미지 저장
            print("선택된 이미지 저장 완료")
        }
        dismiss(animated: true)
    }
    
    @objc
    private func completionButtonPressed() {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        guard let selectedImage = self.selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.6) else {
            print("No Image")
            return
        }
        // 필요한 내용이 다 있는지 검사
        
        let filename = UUID().uuidString + ".jpg"
        guard let entityId = MemberAPIService.userInfo?.memberId else {
            print("No Entity ID")
            return
        }
        
        let entities: [PURLsRequestEntity] = [
            PURLsRequestEntity(
                entityId: entityId,
                images: [PresignedUrlImage(filename: filename, contentType: "image/jpeg")])
        ]
        
        PresignedUrlService.getPresignedUrls(domain: .pet, entities: entities, token: accessToken) { result in
            switch result {
            case .success(let success):
                print(success)
                if let result = success.result {
                    let presignedUrl = result.entities[0].images[0].presignedUrl
                    self.imageKey = result.entities[0].images[0].imageKey
                    self.uploadImageToS3(
                        imageData: imageData,
                        presignedUrl: URL(string: presignedUrl)!) { result in
                        switch result {
                        case .success:
                            let petParameter = PetParameter(
                                name: self.editOrRegistPetView.petNameTextField.text!,
                                size: self.editOrRegistPetView.selectedDogSize!.rawValue,
                                type: self.editOrRegistPetView.dogTypeTextField.text!,
                                gender: self.editOrRegistPetView.selectedDogGender!.rawValue,
                                birth: self.editOrRegistPetView.birthdateSelectButton.titleLabel!.text!,
                                imageKey: self.imageKey!)
                            // 강아지 프로필 올리기 or 수정하기
                            if self.mode == .Edit { // 있으면 수정
                                self.petListViewModel?.patchPet(petId: self.pet!.petId, newInfo: petParameter) {_ in}
                            } else if self.mode == .Regist { // 없으면 새로운 강아지
                                self.petListViewModel?.postPet(newInfo: petParameter) {_ in}
                            }
                            self.navigationController?.popViewController(animated: true)                        case .failure(let error):
                            print("#uploadImageToS3 과정에서 에러", error)
                        }
                    }
                }
            case .failure(let failure):
                print("#getPresignedUrl", failure)
            }
            
        }
        
    }
    
}

enum RegistOrEditMode {
    case Edit, Regist
}

import SwiftUI
#Preview {
    EditOrRegistPetViewController()
}
