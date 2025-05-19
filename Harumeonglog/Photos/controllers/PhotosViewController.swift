//
//  PhotosViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//

import UIKit

// PhotosViewController는 특정 앨범에 있는 사진을 표시하고, 선택 모드로 전환하여 삭제 및 다운로드 기능을 제공하는 뷰 컨트롤러입니다.
class PhotosViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    var album: Album
    
    // 사진 선택 모드 활성화 여부를 나타냅니다.
    private var isSelecting = false
    
    // 현재 선택된 셀들의 인덱스 경로 배열입니다.
    private var selectedIndexPaths: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = photosView
        setCustomNavigationBarConstraints()
        setUpButtons()
    }
    
    lazy var photosView: PhotosView = {
        let view = PhotosView()
        return view
    }()
    
    private func setUpButtons() {
        photosView.PhotosCollectionView.register(PictureCell.self, forCellWithReuseIdentifier: "PictureCell")
        photosView.PhotosCollectionView.delegate = self
        photosView.PhotosCollectionView.dataSource = self
        
        photosView.deleteButton.addTarget(self, action: #selector(deleteSelectedImages), for: .touchUpInside)
        photosView.downloadButton.addTarget(self, action: #selector(downloadSelectedImages), for: .touchUpInside)
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
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = photosView.navigationBar
        navi.configureTitle(title: album.name)
        navi.configureRightButton(text: "선택")
        navi.rightButton.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        navi.configureRightButton()
    }
    
    // 선택 버튼을 눌렀을 때 선택 모드를 토글하고 UI를 갱신
    @objc
    private func didTapSelectButton() {
        isSelecting.toggle()
        let newTitle = isSelecting ? "취소" : "선택"
        photosView.navigationBar.configureRightButton(text: newTitle)
        photosView.bottomActionBar.isHidden = !isSelecting
        photosView.PhotosCollectionView.allowsMultipleSelection = isSelecting

        if !isSelecting {
            // 선택 모드 종료 시 선택 상태 초기화
            for indexPath in selectedIndexPaths {
                if let cell = photosView.PhotosCollectionView.cellForItem(at: indexPath) as? PictureCell {
                    cell.setSelectedBorder(false)
                }
                photosView.PhotosCollectionView.deselectItem(at: indexPath, animated: false)
            }
            selectedIndexPaths.removeAll()
            updateSelectedCountLabel()
        }

        photosView.PhotosCollectionView.reloadData()

        if let addCell = photosView.PhotosCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? PictureCell {
            addCell.addButton.isUserInteractionEnabled = !isSelecting
        }
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    // 선택된 사진 개수를 라벨에 표시
    private func updateSelectedCountLabel() {
        let count = selectedIndexPaths.count
        photosView.selectedCountLabel.text = "\(count)장의 사진이 선택됨"
    }
    
    // 선택된 이미지를 앨범에서 제거하고 컬렉션 뷰를 갱신
    @objc private func deleteSelectedImages() {
        guard !selectedIndexPaths.isEmpty else { return }
        let indices = selectedIndexPaths.map { $0.item - 1 }.sorted(by: >)
        let imageIds = indices.map { album.imageInfos[$0].imageId }
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
            print("토큰이 없습니다.")
            return
        }
        
        let alert = UIAlertController(title: "삭제", message: "이미지를 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            PhotoService.deleteMultipleImage(
                petId: self.album.petId,
                imageIds: imageIds,
                token: token
            ) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        for index in indices {
                            self.album.uiImages.remove(at: index)
                            self.album.imageInfos.remove(at: index)
                        }
                        // 먼저 셀 테두리 및 선택 해제 처리
                        for indexPath in self.selectedIndexPaths {
                            self.photosView.PhotosCollectionView.deselectItem(at: indexPath, animated: false)
                            if let cell = self.photosView.PhotosCollectionView.cellForItem(at: indexPath) as? PictureCell {
                                cell.setSelectedBorder(false)
                            }
                        }
                        self.selectedIndexPaths.removeAll()
                        self.updateSelectedCountLabel()
                        self.photosView.PhotosCollectionView.reloadData()
                        print("이미지 다중 삭제 성공")
                        
                        self.isSelecting = false
                        self.photosView.navigationBar.configureRightButton(text: "선택")
                        self.photosView.bottomActionBar.isHidden = true
                        self.photosView.PhotosCollectionView.allowsMultipleSelection = false
                    }
                case .failure(let error):
                    print("이미지 삭제 실패: \(error)")
                }
            }
        }
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
        

    // 선택된 이미지를 사용자 사진 앨범에 저장
    @objc private func downloadSelectedImages() {
        for indexPath in selectedIndexPaths {
            let index = indexPath.item - 1
            let image = album.uiImages[index]
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}

// MARK: photosCollectionView delegate, datasource
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
    
    // 이미지 선택 메서드
    @objc
    func pickImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    // 이미지 업로드 후 컬렉션 뷰를 갱신
    private func uploadImage(image: UIImage) {
        let imageKey = UUID().uuidString + ".jpg"
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
                print("토큰이 없습니다.")
                return
            }

        PresignedUrlService.fetchPresignedUrl(
            filename: imageKey,
            contentType: "image/jpeg",
            domain: .pet,
            entityId: album.petId,
            token: token
        ) { result in
            switch result {
            case .success(let response):
                print("이미지 업로드 성공: \(response)")
                guard case .result(let presigned) = response.result,
                      let url = URL(string: presigned.presignedUrl) else {
                    print("presigned URL 응답 파싱 실패 또는 잘못된 형식")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
                let imageData = image.jpegData(compressionQuality: 0.8)

                URLSession.shared.uploadTask(with: request, from: imageData) { _, _, error in
                    if let error = error {
                        print("이미지 업로드 실패: \(error)")
                        return
                    }

                    PhotoService.saveImages(petId: self.album.petId, imageKeys: [presigned.imageKey], token: token) { saveResult in
                        switch saveResult {
                        case .success(let saveResponse):
                            DispatchQueue.main.async {
                                if let imageId = saveResponse.result?.imageIds.first {
                                    let newPetImage = PetImage(
                                        imageId: imageId,
                                        imageKey: presigned.imageKey,
                                        createdAt: saveResponse.result?.createdAt ?? ""
                                    )
                                    self.album.imageInfos.append(newPetImage)
                                    self.album.uiImages.append(image)
                                    // 선택 해제 및 테두리 제거
                                    for indexPath in self.photosView.PhotosCollectionView.indexPathsForSelectedItems ?? [] {
                                        self.photosView.PhotosCollectionView.deselectItem(at: indexPath, animated: false)
                                        if let cell = self.photosView.PhotosCollectionView.cellForItem(at: indexPath) as? PictureCell {
                                            cell.setSelectedBorder(false)
                                        }
                                    }
                                    self.photosView.PhotosCollectionView.reloadData()
                                    print("이미지 저장 성공")
                                }
                            }
                        case .failure(let error):
                            print("이미지 저장 실패: \(error)")
                        }
                    }

                }.resume()

            case .failure(let error):
                print("Presigned URL 요청 실패: \(error)")
            }
        }
        
    }
}

// MARK: imageCollectionview delegate, datasource
extension PhotosViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.uiImages.count + 1  // 첫 번째 셀은 추가 버튼
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCell
        
        if indexPath.item == 0 {
            cell.configure(isAddButton: true)
            cell.addButton.isUserInteractionEnabled = !isSelecting
            if !isSelecting {
                cell.addButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
            }
        } else {
            let image = album.uiImages[indexPath.item - 1]
            cell.configure(isAddButton: false, image: image)
        }
        
        return cell
    }
    
    // 셀 선택 시 선택 모드일 경우 선택 처리, 아닐 경우 상세 화면으로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PictureCell else { return }

        // + 버튼 셀은 무조건 선택 취소 처리
        if indexPath.item == 0 {
            collectionView.deselectItem(at: indexPath, animated: false)
            return
        }

        guard isSelecting else {
            let imageId = album.imageInfos[indexPath.item - 1].imageId
            let image = album.uiImages[indexPath.item - 1]
            guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
            PhotoService.fetchImageDetail(imageId: imageId, token: token) { result in
                switch result {
                case .success(let response):
                    print("단일 이미지 조회 성공")
                    guard response.isSuccess else { return }
                    switch response.result {
                    case .result(let detail):
                        DispatchQueue.main.async {
                            let detailVC = PhotoDetailViewController(image: image, imageInfo: detail, album: self.album)
                            self.navigationController?.pushViewController(detailVC, animated: true)
                        }
                    case .message(let message):
                        print("이미지 정보 오류: \(message)")
                    }
                case .failure(let error):
                    print("단일 이미지 조회 실패: \(error)")
                }
            }
            return
        }

        // 선택 모드에서만 셀 테두리 적용
        cell.setSelectedBorder(true)
        selectedIndexPaths.append(indexPath)
        updateSelectedCountLabel()
    }

    // 셀 선택 해제 시 선택 목록에서 삭제
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard indexPath.item != 0 else { return } // + 버튼 무시
        guard let cell = collectionView.cellForItem(at: indexPath) as? PictureCell else { return }
        cell.setSelectedBorder(false)
        if let index = selectedIndexPaths.firstIndex(of: indexPath) {
            selectedIndexPaths.remove(at: index)
            updateSelectedCountLabel()
        }
    }
}
