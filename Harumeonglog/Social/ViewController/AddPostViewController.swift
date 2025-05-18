//
//  AddPostViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/27/25.
//

import UIKit
import Alamofire

protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}


class AddPostViewController: UIViewController, CategorySelectionDelegate {
    
    let socialPostService = SocialPostService()
    var postTitle: String = ""
    var selectedCategory: String?
    var postContent: String = ""
    private var postImagesURL: [URL] = []
    private var postImages: [UIImage] = []
    private var presignedURLResult: [String] = []

    private lazy var addPostView: AddPostView = {
        let view = AddPostView()
        view.delegate = self
        view.backgroundColor = .background
        view.imageCollectionView.delegate = self
        view.imageCollectionView.dataSource = self
        view.addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addPostView
        setCustomNavigationBarConstraints()
        hideKeyboardWhenTappedAround()
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = addPostView.navigationBar
        navi.configureRightButton(text: "개시")
        navi.rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    
    @objc func didTapRightButton() {
        
        let postTitle = addPostView.titleTextField.text ?? ""
        let postContent = addPostView.contentTextView.text ?? ""
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
             print("토큰 없음")
             return
         }
        
         // 서버로 제목, 컨텐츠 , 이미지 url, 카테고리 넘겨주기
        socialPostService.sendPostToServer(
            postCategory: selectedCategory!,
            title: postTitle,
            content: postContent,
            postImageList: presignedURLResult,
            token: token
        ) { [weak self] result in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("게시글 생성 성공")
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    print("서버 응답 에러: \(response.message)")
                }

            case .failure(let error):
                if let afError = error as? AFError,
                   let underlyingError = afError.underlyingError as? URLError,
                   let data = underlyingError.userInfo["com.alamofire.serialization.response.error.data"] as? Data {
                    // 경우 1: underlyingError에서 data 꺼낼 수 있을 때
                    let jsonString = String(data: data, encoding: .utf8) ?? "응답 없음"
                    print("🧾 서버 응답 JSON:\n\(jsonString)")
                } else if let afError = error as? AFError,
                          let data = afError.underlyingError as? Data {
                    // 경우 2: 일반적인 경우
                    let jsonString = String(data: data, encoding: .utf8) ?? "응답 없음"
                    print("🧾 서버 응답 JSON:\n\(jsonString)")
                } else {
                    print("❗️ underlyingError 없음 또는 디코딩 불가")
                }

                print("❌ 게시글 전송 실패: \(error.localizedDescription)")

            }
        }
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addImageButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true)
    }
    
    func didSelectCategory(_ category: String) {
        print("선택된 카테고리: \(category)")
        selectedCategory = socialCategoryKey.tagsMap[category] ?? "unkonwn"
    }

}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        }
        else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if let imageURL = info[.imageURL] as? URL {
            print("이미지 URL: \(imageURL)")
            postImagesURL.append(imageURL)
        } else {
            print("이미지 URL을 가져올 수 없음")
        }
        
        // 선택된 이미지를 배열에 추가
        if let image = selectedImage {
            guard let token = KeychainService.get(key: K.Keys.accessToken) else {
                print("토큰 없음")
                return
            }
            
            PresignedUrlService.fetchPresignedUrl(
                filename: UUID().uuidString + ".jpg",
                contentType: "image/jpeg",
                domain: .post,
                entityId: 0,
                token: token
            ) { [weak self] result in
                switch result {
                case .success(let response):
                    switch response.result {
                    case .result(let presignedUrlResult):
                        print("Presigned URL 발급 성공: \(presignedUrlResult.presignedUrl)")
                        self?.presignedURLResult.append(presignedUrlResult.presignedUrl)
                    case .message(let message):
                        print("Error: \(message)")
                    }
                case .failure(let error):
                    print("Presigned URL 발급 실패: \(error.localizedDescription)")
                }
            }
            
            postImages.append(image)
            addPostView.imageCollectionView.reloadData()
            addPostView.imageCollectionView.layoutIfNeeded()
            addPostView.addImageCount.text = "\(postImages.count)/10"
        }
        
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension AddPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageViewCell", for: indexPath) as? AddImageViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = postImages[indexPath.row]
        
        // 삭제 버튼 눌렸을 때 동작
        cell.onDelete = { [weak self] in
            self?.postImages.remove(at: indexPath.row)
            self?.presignedURLResult.remove(at: indexPath.row)
            self?.addPostView.imageCollectionView.reloadData()
            self?.addPostView.addImageCount.text = "\(self?.postImages.count ?? 0)/10"
        }

        return cell
    }
}
