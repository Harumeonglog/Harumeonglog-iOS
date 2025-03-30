//
//  AddPostViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/27/25.
//

import UIKit

class AddPostViewController: UIViewController {
    
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
    }
    
    @objc private func addImageButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true)
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


extension AddPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
