//
//  AddPostViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/27/25.
//

import UIKit
import Alamofire

class AddPostViewController: UIViewController {
    
    let socialPostService = SocialPostService()
    var postTitle: String = ""
    var selectedCategory: String?
    var postContent: String = ""
    private var postImages: [UIImage] = []          // 사용자가 고른 이미지
    private var imageKeys: [String] = []
    private var isSubmitting = false                // 게시글 생성 중복 방지 플래그
    private let maxImageCount = 10

    private lazy var addPostView: AddPostView = {
        let view = AddPostView()
        view.delegate = self
        view.backgroundColor = .background
        view.imageCollectionView.delegate = self
        view.imageCollectionView.dataSource = self
        view.addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        view.titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.contentTextView.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addPostView
        setCustomNavigationBarConstraints()
        hideKeyboardWhenTappedAround()
        swipeRecognizer()
        updateRightButtonState()
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
        if postImages.isEmpty {
            createPost()
            return
        }
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        let imageInfos = postImages.enumerated().map { (index, _) -> PresignedUrlImage in
            return PresignedUrlImage(
                filename: "\(postTitle)_\(index)",
                contentType: "image/jpeg"
            )
        }
        requestPresignedURLS(images: imageInfos, token: token)
    }
    
    
    private func requestPresignedURLS(images: [PresignedUrlImage], token: String) {
        // entityId = 0으로 고정
        let entity = PURLsRequestEntity(entityId: 0, images: images)
        PresignedUrlService.getPresignedUrls(domain: .post, entities: [entity], token: token) { [weak self] result in
            switch result {
            case .success(let response):
                print("presignedURL 발급 성공")
                self?.uploadImagesToPresignedURL(response.result!)
            case .failure(let error):
                print("presignedURL 발급 실패: \(error)")
            }
        }
    }

    
    private func uploadImagesToPresignedURL(_ result: PUrlsResult) {
        guard let presignedEntity = result.entities.first else { return }

        let presignedData = presignedEntity.images
        guard presignedData.count == postImages.count else { return }  // presingedURL에 올라간 이미지 개수가 맞는지 확인
        
        let dispatchGroup = DispatchGroup()
        var uploadErrorOccurred = false
        
        for (index, image) in postImages.enumerated() {
            dispatchGroup.enter()
            guard let imageData = image.jpegData(compressionQuality: 0.8),          // 0.8 압축: 고화질이면서 용량도 적당하게 균형 맞추기 위함
                  let url = URL(string: presignedData[index].presignedUrl) else {
                dispatchGroup.leave()
                continue
            }
            
            uploadImageToS3(imageData: imageData, presignedUrl: url) { [weak self] result in
                switch result {
                case .success:
                    self?.imageKeys.append(presignedData[index].imageKey)
                case .failure(let error):
                    print("이미지 업로드 실패: \(error)")
                    uploadErrorOccurred = true
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            if uploadErrorOccurred {
                print("업로드 실패로 게시글 생성 중단")
            } else {
                self!.createPost()
            }
        }
    }
    
    private func createPost() {
        postTitle = addPostView.titleTextField.text ?? ""
        postContent = addPostView.contentTextView.text ?? ""
        
        showLoadingView()
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        socialPostService.sendPostToServer(
            postCategory: selectedCategory!,
            title: self.postTitle,
            content: self.postContent,
            postImageList: imageKeys,
            token: token
        ) { result in
            
            self.hideLoadingView()
            
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("게시글 생성 성공")
                    DispatchQueue.main.async {
                        self.addPostView.navigationBar.rightButton.isUserInteractionEnabled = true  // 버튼 다시 활성화
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                print("게시글 전송 실패: \(error.localizedDescription)")
            }
        }
    }
    

    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addImageButtonTapped() {
        if postImages.count >= maxImageCount {
            print("최대 10장까지만 업로드 가능")
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true)
    }
    
}

extension AddPostViewController: UITextViewDelegate, CategorySelectionDelegate {

    func textViewDidChange(_ textView: UITextView) {
        addPostView.contentTextViewPlaceHolderLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        updateRightButtonState()
    }
    
    @objc func textFieldDidChange() {
        updateRightButtonState()
    }
    
    internal func didSelectCategory(_ category: String) {
        print("선택된 카테고리: \(category)")
        selectedCategory = socialCategoryKey.tagsKortoEng[category] ?? "unknown"
        updateRightButtonState()
    }

    private func updateRightButtonState() {
        self.postTitle = addPostView.titleTextField.text ?? ""
        self.postContent = addPostView.contentTextView.text ?? ""
        
        let isFormValid = !self.postTitle.trimmingCharacters(in: .whitespaces).isEmpty && selectedCategory != nil
        addPostView.navigationBar.rightButton.isHidden = !isFormValid
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
        // 선택된 이미지를 배열에 추가
        if let image = selectedImage {
            postImages.append(image)
            addPostView.imageCollectionView.reloadData()
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
            //self?.presignedURLResult.remove(at: indexPath.row)
            self?.addPostView.imageCollectionView.reloadData()
            self?.addPostView.addImageCount.text = "\(self?.postImages.count ?? 0)/10"
        }
        return cell
    }
}
