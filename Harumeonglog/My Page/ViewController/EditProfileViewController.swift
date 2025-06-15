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
    private var userInfo: UserInfo?
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
    
    public func configure() {
        if let userInfo = MemberAPIService.userInfo {
            editProfileView.nicknameTextField.text = userInfo.nickname
            if let url = userInfo.image {
                editProfileView.setPrifileImageByURL(URL(string: url)!)
            }
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
        // editProfileView.navigationBar.rightButton.isEnabled = editProfileView.nicknameTextField.text?.count ?? 0 > 0
    }
    
    @objc
    private func completionButtonPressed() {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        guard let nickname = editProfileView.nicknameTextField.text, !nickname.isEmpty else { return }
        guard let selectedImage = self.selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.6) else {
            print("No Image")
            self.updateProfile(image: nil, nickname: nickname)
            return
        }
        
        let filename = UUID().uuidString + ".jpg"
        guard let entityId = MemberAPIService.userInfo?.memberId else {
            print("No Entity ID")
            return
        }
        
        // Presigned URL 요청 후 이미지 업로드
        PresignedUrlService.fetchPresignedUrl(
            filename: filename,
            contentType: "image/jpeg",
            domain: .pet,
            entityId: entityId,
            token: accessToken
        ) { result in
            switch result {
            case .success(let apiResponse):
                print("이미지 업로드 성공: \(apiResponse)")
                guard case .result(let presigned) = apiResponse.result,
                      let presignedUrl = URL(string: presigned.presignedUrl) else {
                    print("presigned URL 응답 파싱 실패 또는 잘못된 형식")
                    return
                }
                self.imageKey = presigned.imageKey
                self.uploadImageToS3(imageData: imageData, presignedUrl: presignedUrl) { result in
                    switch result {
                    case .success :
                        self.updateProfile(image: self.imageKey, nickname: self.editProfileView.nicknameTextField.text!)
                    case .failure(let error) :
                        print("#PresignedUrlService.fetchPresignedUrl ", error)
                        break
                    }
                }
            case .failure(let error):
                print("Presigned URL 요청 실패: \(error)")
            }
        }
    }
    
//    private func uploadImageToS3(imageData: Data, presignedUrl: URL, completion: @escaping (Result<Bool, Error>) -> Void) {
//        // URLRequest 생성
//        var request = URLRequest(url: presignedUrl)
//        request.httpMethod = "PUT" // S3 Presigned URL은 PUT 메소드 사용
//        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type") // 이미지 타입에 맞게 설정
//        
//        // Alamofire를 사용한 업로드 구현
//        AF.upload(imageData, with: request)
//            .response { response in  // .responseJSON 대신 .response 사용
//                if let error = response.error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                // 상태 코드 확인 (200 또는 204는 성공)
//                if let statusCode = response.response?.statusCode,
//                   (200...299).contains(statusCode) {
//                    print("#uploadImageToS3: successful")
//                    completion(.success(true))
//                } else {
//                    let error = NSError(
//                        domain: "S3UploadError",
//                        code: response.response?.statusCode ?? -1,
//                        userInfo: [NSLocalizedDescriptionKey: "업로드 실패"]
//                    )
//                    print("#uploadImageToS3: \(error)")
//                    completion(.failure(error))
//                }
//            }
//    }
    
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
            print("선택된 이미지 저장 완료")
        }
        dismiss(animated: true)
    }
    
    private func updateProfile(image: String?, nickname: String) {
        print("image: ", image)
        MemberAPIService.patchInfo(
            param: InfoParameters(imageKey: image, nickname: nickname)
        ) { [weak self] code in
            guard let self = self else { return }
            switch code {
            case .COMMON200:
                print("프로필 업데이트 성공")
                self.navigationController?.popViewController(animated: true)
            case .AUTH401:
                RootViewControllerService.toLoginViewController()
            case .ERROR500:
                print("프로필 업데이트 서버에러 발생")
                break
            default:
                print("프로필 업데이트 \(code)에러 발생")
                break
            }
        }
    }
}
