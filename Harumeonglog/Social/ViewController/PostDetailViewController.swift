//
//  PostDetailViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/24/25.
//

import UIKit
import SDWebImage

class PostDetailViewController: UIViewController {
    
    let socialPostService = SocialPostService()

    var postId : Int?
    private var isLiked: Bool = false
    private var photos = [UIImage(named:"testImage"), UIImage(named: "testImage"), UIImage(named: "testImage")]
    private var postDetail: [PostDetailResponse] = []
    private var memberInfo: [MemberInfoResponse] = []


    private lazy var postDetailView: PostDetailView = {
        let view = PostDetailView()
        view.backgroundColor = .background
        
        view.postImageScrollView.delegate = self
        view.commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        
        // 버튼에 더블 탭 제스처 추가
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(likeButtonDoubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
                
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = postDetailView
        setCustomNavigationBarConstraints()
        postSettingButton()
        fetchPostDetailsFromServer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentScrollView()
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = postDetailView.navigationBar
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
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
                        
                        // self.photos.removeAll()
                        
                        for urlString in postDetail.postImageList {
                            if let urlString = urlString, let url = URL(string: urlString) {
                                URLSession.shared.dataTask(with: url) { data, _, _ in
                                    if let data = data, let image = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            self.photos.append(image)
                                        }
                                    }
                                }.resume()
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.postDetailView.configure(
                                with: postDetail, member: postDetail.memberInfoResponse)
                        }
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
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func commentButtonTapped() {
        let commentVC = CommentViewController()
        commentVC.postId = postId
        commentVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    // 좋아요 버튼 더블탭
    @objc func likeButtonDoubleTapped() {
        isLiked.toggle()
        
        let imageName = isLiked ? "heart.fill" : "heart"
        let tintColor = isLiked ? UIColor.red00 : UIColor.gray02
        
        postDetailView.likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        postDetailView.likeButton.tintColor = tintColor
    }
    
    private func postSettingButton() {
        let popUpButtonClosure = { (action: UIAction) in
            if action.title == "수정" {
                let modifyPostVC = ModifyPostViewController()
                self.navigationController?.pushViewController(modifyPostVC, animated: true)
            }
            
            if action.title == "삭제" {
            
            }
        }
        
        let modifyTitle = NSAttributedString(
            string: "수정",
            attributes: [
                .foregroundColor: UIColor.gray00,
                .font: UIFont.headline
            ]
        )
        
        let deleteTitle = NSAttributedString(
            string: "삭제",
            attributes: [
                .foregroundColor: UIColor.red00,
                .font: UIFont.headline
            ]
        )
        
        let modifyAction = UIAction(title: "수정", handler: popUpButtonClosure)
        let deleteAction = UIAction(title: "삭제", handler: popUpButtonClosure)
        modifyAction.setValue(modifyTitle, forKey: "attributedTitle")
        deleteAction.setValue(deleteTitle, forKey: "attributedTitle") // 삭제 버튼의 색상을 변경

        let menu = UIMenu(options: .displayInline, children: [modifyAction, deleteAction])
        postDetailView.postSetting.menu = menu
        postDetailView.postSetting.showsMenuAsPrimaryAction = true
    }
}


// 게시글 이미지에 대한 scrollView
extension PostDetailViewController: UIScrollViewDelegate {
    func contentScrollView() {
        postDetailView.postImageScrollView.layoutIfNeeded()

        for i in 0..<photos.count {
            let imageView = UIImageView()
            let positionX = postDetailView.postImageScrollView.frame.width * CGFloat(i)
            
            imageView.frame = CGRect(x: positionX, y: 0, width: postDetailView.postImageScrollView.frame.width, height: postDetailView.postImageScrollView.frame.height)
            imageView.image = photos[i]
            imageView.contentMode = .scaleAspectFit
            
            postDetailView.postImageScrollView.addSubview(imageView)
        }
        
        // 전체 컨텐츠 크기를 설정하여 스크롤을 가능하게 만듦
        postDetailView.postImageScrollView.contentSize = CGSize(width: postDetailView.postImageScrollView.frame.width * CGFloat(photos.count), height: postDetailView.postImageScrollView.frame.height)
        
        // 페이지 컨트롤 설정
        postDetailView.postImagePageControl.numberOfPages = photos.count
        postDetailView.postImagePageControl.currentPage = 0
        
        // 이미지가 1개면 pageControl 숨김
        postDetailView.postImagePageControl.isHidden = photos.count == 1 ? true : false
    }
    
    // 스크롤할 때 페이지 변경
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        postDetailView.postImagePageControl.currentPage = Int(pageIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        postDetailView.postImagePageControl.isHidden = false
    }
    
    // 스크롤 후 일정 시간 후에 pageControl 숨기기
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.postDetailView.postImagePageControl.isHidden = true
        }
    }
    
}
