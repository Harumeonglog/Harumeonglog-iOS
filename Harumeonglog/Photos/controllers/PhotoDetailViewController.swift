//
//  PhotoDetailViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var image: UIImage
    var album: Album
    var imageInfo: PetImageDetail

    init(image: UIImage, imageInfo: PetImageDetail, album: Album){
        self.image = image
        self.imageInfo = imageInfo
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = photoDetailView
        setCustomNavigationBarConstraints()
        
        photoDetailView.deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        photoDetailView.downloadButton.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
    }
    
    //탭바 숨기기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
    private lazy var photoDetailView: PhotoDetailView = {
        let view = PhotoDetailView(image: image, imageInfo: imageInfo, album: album)
        return view
    }()
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = photoDetailView.navigationBar
        navi.configureTitle(title: album.name)
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapDeleteButton(){
        let imageId = imageInfo.imageId
        let alert = UIAlertController(title: "삭제", message: "이미지를 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title:"삭제", style: .destructive, handler: { _ in
            guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else {return}
            
            PhotoService.deleteImage(imageId: imageId, token: accessToken){ result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if let photosVC = self.navigationController?.viewControllers.compactMap({ $0 as? PhotosViewController }).last {
                            if let index = photosVC.album.imageInfos.firstIndex(where: { $0.imageId == self.imageInfo.imageId }) {
                                photosVC.album.imageInfos.remove(at: index)
                                photosVC.album.uiImages.remove(at: index)
                                photosVC.photosView.PhotosCollectionView.reloadData()
                            }
                        }
                        self.navigationController?.popViewController(animated: true)
                        print("이미지 삭제 성공")
                    }
                case .failure(let error):
                    print ("이미지 삭제 실패: ", error)
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    @objc
    private func didTapDownloadButton() {
        let alert = UIAlertController(title: "저장", message: "사진을 저장하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.requestPhotoAuthorizationIfNeeded { granted in
                guard granted else { return }
                UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(self.saveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }))
        present(alert, animated: true)
    }

    private func requestPhotoAuthorizationIfNeeded(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        default:
            completion(false)
        }
    }

    @objc private func saveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            print("사진 저장 실패: \(error)")
            return
        }
        print("사진 저장 성공")
        let alert = UIAlertController(title: nil, message: "다운로드 되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
