//
//  PhotosViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//

import UIKit

class PhotosViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    var album: Album
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = photosView
        title = album.name
        photosView.PhotosCollectionView.register(PictureCell.self, forCellWithReuseIdentifier: "PictureCell")
        photosView.PhotosCollectionView.delegate = self
        photosView.PhotosCollectionView.dataSource = self
    }
    
    private lazy var photosView: PhotosView = {
        let view = PhotosView()
        return view
    }()
    
    @objc
    private func addImageButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "카메라로 촬영", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "앨범에서 가져오기", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
}

extension PhotosViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // 이미지 피커에서 이미지를 선택하지 않고 취소했을 때 호출되는 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    // 이미지 피커에서 이미지 선택했을 때 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            uploadImage(image: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            uploadImage(image: originalImage)
        }
        picker.dismiss(animated: true)
    }
    private func uploadImage(image: UIImage) {
        album.images.append(image)
        
        DispatchQueue.main.async {
            self.photosView.PhotosCollectionView.reloadData()
        }
    }
    
    // 이미지 선택 메서드
    @objc
    func pickImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
}

// MARK: imageCollectionview delegate, datasource
extension PhotosViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCell
        
        if indexPath.item == 0 {
            cell.configure(isAddButton: true)
            cell.addButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        } else {
            let image = album.images[indexPath.item - 1]
            cell.configure(isAddButton: false, image: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            addImageButtonTapped()
        }
    }
}
