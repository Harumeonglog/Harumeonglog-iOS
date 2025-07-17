//
//  ModifyPostViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 4/30/25.
//


import UIKit
import SDWebImage


protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

class ModifyPostViewController: UIViewController, CategorySelectionDelegate {
    
    var postId: Int?
    let socialPostService = SocialPostService()
    var postTitle: String = ""
    var selectedCategory: String?
    var postContent: String = ""
    private var postImages: [UIImage] = []
    private var postImagesURL: [String] = []
    private var imageKeys: [String] = []

    private lazy var addPostView: AddPostView = {
        let view = AddPostView()
        view.backgroundColor = .background
        view.delegate = self
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
        fetchPostDetailsFromServer()
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = addPostView.navigationBar
        navi.configureRightButton(text: "수정")
        navi.rightButton.setTitleColor(.red00, for: .normal)
        navi.rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private func fetchPostDetailsFromServer() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {  return  }
        
        socialPostService.getPostDetailsFromServer(postId: postId!, token: token){ [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if response.isSuccess {
                    if let postDetail = response.result {
                        print("게시글 조회 성공")
                        self.postImagesURL.append(contentsOf: postDetail.postImageList.compactMap { $0 })
                        print("\(self.postImagesURL)")
                        // 서버 (영어) -> 한국어로 저장
                        self.selectedCategory = socialCategoryKey.tagsEngKorto[postDetail.postCategory]

                        DispatchQueue.main.async {
                            self.addPostView.configure(with: postDetail)
                            self.addPostView.imageCollectionView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print("게시글 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapRightButton(){      // 수정 버튼 탭함
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        if self.postImages.isEmpty && self.postImagesURL.isEmpty {
            modifyPost(imageKeys: nil)
            return
        } else if self.postImages.isEmpty {
            self.imageKeys = self.postImagesURL.compactMap {
                URL(string: $0)?.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            }
            modifyPost(imageKeys: self.imageKeys)
            return
        }
        
        // presingedURL batch 요청을 이미지 정보 만들기
        let imageInfos = postImages.enumerated().map { (index, _) -> PresignedUrlImage in
            return PresignedUrlImage(
                filename: "\(postTitle)_\(index)",
                contentType: "image/jpeg"
            )
        }
        requestPresignedURLS(images: imageInfos, token: token)
    }
    
    private func requestPresignedURLS(images: [PresignedUrlImage], token: String) {
        let entity = PURLsRequestEntity(entityId: self.postId!, images: images)
        
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
        guard presignedData.count == postImages.count else { return }
        
        let dispatchGroup = DispatchGroup()
        var uploadErrorOccurred = false
        
        for (index, image) in postImages.enumerated() {
            dispatchGroup.enter()
            guard let imageData = image.jpegData(compressionQuality: 0.8),
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
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                if uploadErrorOccurred {
                    print("업로드 실패로 게시글 수정 중단")
                } else {
                    
                    let allKeys: [String] = self!.postImagesURL.compactMap {
                        // 전체 URL에서 마지막 key만 추출
                        URL(string: $0)?.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
                    } + self!.imageKeys

                    self!.modifyPost(imageKeys: allKeys)
                }
            }
        }
    }
    
    private func modifyPost(imageKeys: [String]?) {
        postTitle = addPostView.titleTextField.text ?? ""
        postContent = addPostView.contentTextView.text ?? ""

        guard let token = KeychainService.get(key: K.Keys.accessToken) else {  return  }

        socialPostService.modifyPostToServer(
            postId: self.postId!, postCategory: socialCategoryKey.tagsKortoEng[self.selectedCategory!] ?? "unknown",
            title: self.postTitle, content: self.postContent,
            postImageList: imageKeys!,
            token: token) { result in
                switch result {
                case .success(let response):
                    if response.isSuccess {
                        print("게시글 수정 성공")
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("게시글 전송 실패: \(error.localizedDescription)")
                }
            }
    }
    
    @objc private func addImageButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true)
    }
    
    func didSelectCategory(_ category: String) {
        print("선택된 카테고리: \(category)")
        selectedCategory = category
    }

}


extension ModifyPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            print("이미지 추가됨: \(image)")  // 이미지가 배열에 추가되는지 확인
            addPostView.imageCollectionView.reloadData()
            addPostView.addImageCount.text = "\(postImages.count)/10"
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension ModifyPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImages.count + postImagesURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageViewCell", for: indexPath) as? AddImageViewCell else {
            return UICollectionViewCell()
        }

        if indexPath.row < postImagesURL.count {
            // 서버에서 가져온 이미지 처리
            cell.configure(with: postImagesURL[indexPath.row]) // URL 로딩
        } else {
            // 새로 추가한 이미지 처리
            let localImageIndex = indexPath.row - postImagesURL.count
            cell.imageView.image = postImages[localImageIndex]
        }

        // 삭제 버튼 눌렸을 때
        cell.onDelete = { [weak self] in
            guard let self = self else { return }

            if indexPath.row < self.postImagesURL.count {
                // 서버 이미지 삭제
                self.postImagesURL.remove(at: indexPath.row)
            } else {
                // 새 이미지 삭제
                let localIndex = indexPath.row - self.postImagesURL.count
                self.postImages.remove(at: localIndex)
            }

            self.addPostView.imageCollectionView.reloadData()
            self.addPostView.addImageCount.text = "\(self.postImages.count + self.postImagesURL.count)/10"
        }

        return cell
    }

}
