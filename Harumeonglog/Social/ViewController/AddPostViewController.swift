//
//  AddPostViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/27/25.
//

import UIKit

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
        
        // 서버로 제목, 컨텐츠 , 이미지 url, 카테고리 넘겨주기
        socialPostService.postPostToServer(
            title: postTitle,
            postCategory: selectedCategory!,
            content: postContent,
            postImageList: postImagesURL
        ) { [weak self] success in
            if success {
                self?.navigationController?.popViewController(animated: true)
            } else {
                print("게시글 생성 실패")
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
            postImages.append(image)
            print("이미지 추가됨: \(image)")  // 이미지가 배열에 추가되는지 확인
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
            self?.addPostView.imageCollectionView.reloadData()
            self?.addPostView.addImageCount.text = "\(self?.postImages.count ?? 0)/10"
        }

        return cell
    }
}
