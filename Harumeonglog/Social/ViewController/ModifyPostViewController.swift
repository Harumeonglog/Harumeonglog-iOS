//
//  ModifyPostViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 4/30/25.
//


import UIKit

class ModifyPostViewController: UIViewController {
    
    var postId: Int?
    let socialPostService = SocialPostService()
    private var postImages: [UIImage] = []

    private lazy var addPostView: AddPostView = {
        let view = AddPostView()
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
        
        fetchPostDetailsFromServer()
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = addPostView.navigationBar
        navi.configureRightButton(text: "수정")
        navi.leftArrowButton.isHidden = true
        navi.rightButton.setTitleColor(.red00, for: .normal)
        navi.rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
    }
    
    private func fetchPostDetailsFromServer() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
             print("토큰 없음")
             return
         }
        
        socialPostService.getPostDetailsFromServer(postId: postId!, token: token){ [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if response.isSuccess {
                    if let postDetail = response.result {
                        print("게시글 조회 성공")
            
    
                    } else {
                        print("결과 데이터가 비어있습니다.")
                    }
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("게시글 조회 실패: \(error.localizedDescription)")
            }
        }

    }
    
    
    @objc
    private func didTapRightButton(){      // 수정 버튼 탭함
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addImageButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true)
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
        return postImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageViewCell", for: indexPath) as? AddImageViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = postImages[indexPath.row]
        print("이미지 설정됨: \(postImages[indexPath.row])")

        // 컬렉션 뷰 업데이트
        addPostView.imageCollectionView.reloadData()
        addPostView.imageCollectionView.layoutIfNeeded()
        
        return cell
    }
}
