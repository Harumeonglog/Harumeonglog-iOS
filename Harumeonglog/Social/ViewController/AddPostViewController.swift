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
    private var postImages: [UIImage] = []          // 사용자가 고른 이미지
    private var imageKeys: [String] = []
    

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
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        // presingedURL batch 요청을 이미지 정보 만들기
        let imageInfos = postImages.enumerated().map { (index, _) -> PresignedUrlImage in
            return PresignedUrlImage(
                filename: "\(postTitle)_\(index)",
                contentType: "image/jpeg"
            )
        }
        
        // presignedURL batch 발급 요청
        PresignedUrlService.fetchBatchPresignedUrls(
              images: imageInfos,
              domain: .post,
              entityId: 0,
              token: token
          ) { [weak self] result in
              switch result {
              case .success(let response):
                  let presignedData = response.result.images
                  guard presignedData.count == self?.postImages.count else {
                      print("이미지 개수 불일치")
                      return
                  }

                  // 각 presigned URL에 이미지 업로드
                  let dispatchGroup = DispatchGroup()
                  var uploadErrorOccurred = false

                  for (index, image) in self!.postImages.enumerated() {
                      dispatchGroup.enter()
                      guard let imageData = image.jpegData(compressionQuality: 0.8),
                            let url = URL(string: presignedData[index].presignedUrl) else {
                          dispatchGroup.leave()
                          continue
                      }

                      self?.uploadImageToS3(imageData: imageData, presignedUrl: url) { result in
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

                  // 모든 이미지 업로드 완료 후 게시글 생성
                  dispatchGroup.notify(queue: .main) {
                      if uploadErrorOccurred {
                          print("업로드 실패로 게시글 생성 중단")
                          return
                      }

                      self?.socialPostService.sendPostToServer(
                          postCategory: self?.selectedCategory ?? "unknown",
                          title: postTitle,
                          content: postContent,
                          postImageList: self?.imageKeys ?? [],
                          token: token
                      ) { result in
                          switch result {
                          case .success(let response):
                              if response.isSuccess {
                                  print("게시글 생성 성공")
                                  self?.navigationController?.popViewController(animated: true)
                              } else {
                                  print("서버 응답 에러: \(response.message)")
                              }
                          case .failure(let error):
                              print("게시글 전송 실패: \(error.localizedDescription)")
                          }
                      }
                  }

              case .failure(let error):
                  print("Presigned URL 발급 실패: \(error)")
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
        selectedCategory = socialCategoryKey.tagsKortoEng[category] ?? "unkonwn"
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
        
//        if let imageURL = info[.imageURL] as? URL {
//            print("이미지 URL: \(imageURL)")
//            postImagesURL.append(imageURL)
//        } else {
//            print("이미지 URL을 가져올 수 없음")
//        }
        
        // 선택된 이미지를 배열에 추가
        if let image = selectedImage {
//            guard let token = KeychainService.get(key: K.Keys.accessToken) else {
//                print("토큰 없음")
//                return
//            }
//            
//            PresignedUrlService.fetchPresignedUrl(
//                filename: "\(self.postTitle)",      // post 제목으로 fileName 보냄
//                contentType: "image/jpeg",
//                domain: .post,
//                entityId: 0,
//                token: token
//            ) { [weak self] result in
//                switch result {
//                case .success(let response):
//                    switch response.result {
//                    case .result(let presignedUrlResult):
//                        print("Presigned URL 발급 성공: \(presignedUrlResult.presignedUrl)")
//                        self?.presignedURLResult = presignedURLResult.presignedUrl
//                        self?.imageKey = presignedUrlResult.imageKey
//                    case .message(let message):
//                        print("Error: \(message)")
//                    }
//                case .failure(let error):
//                    print("Presigned URL 발급 실패: \(error.localizedDescription)")
//                }
//            }
            
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
            //self?.presignedURLResult.remove(at: indexPath.row)
            self?.addPostView.imageCollectionView.reloadData()
            self?.addPostView.addImageCount.text = "\(self?.postImages.count ?? 0)/10"
        }

        return cell
    }
}
