//
//  WalkingVC+Camera.swift
//  Harumeonglog
//
//  Created by 김민지 on 7/17/25.
//

import Foundation
import UIKit

// MARK: 사진 촬영 후 이미지 전송하기
extension WalkingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func cameraBtnTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("이미지를 가져오지 못했습니다.")
            return
        }
        walkImages.append(image)

        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        // 여기서 서버로 이미지 전송
        let index = walkImages.count - 1
        let imageInfos = [
            PresignedUrlImage(filename: "산책id:\(walkId)_\(index)", contentType: "image/jpeg")
        ]
        requestPresignedURLS(images: imageInfos, token: token)
    }
    
    
    func requestPresignedURLS(images: [PresignedUrlImage], token: String) {
        // petId 하나당 하나의 PURLsRequestEntity 생성
        let entities = selectedPetIds.map { petId in
            return PURLsRequestEntity(entityId: petId, images: images)
        }
        PresignedUrlService.getPresignedUrls(domain: .pet, entities: entities, token: token) { [weak self] result in
            switch result {
            case .success(let response):
                print("presignedURL 발급 성공")
                self?.uploadImagesToPresignedURL(response.result!)
            case .failure(let error):
                print("presignedURL 발급 실패: \(error)")
            }
        }
    }
    
    func uploadImagesToPresignedURL(_ result: PUrlsResult) {
        guard let presignedEntity = result.entities.first else { return }
        let presignedData = presignedEntity.images
        
        for (index, image) in walkImages.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8),
                  let url = URL(string: presignedData[index].presignedUrl) else {
                continue
            }
            uploadImageToS3(imageData: imageData, presignedUrl: url) { [weak self] result in
                switch result {
                case .success:
                    self?.imageKeys.append(presignedData[index].imageKey)
                case .failure(let error):
                    print("이미지 업로드 실패: \(error)")
                }
            }
        }
    }
}
