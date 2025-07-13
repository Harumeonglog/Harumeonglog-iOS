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
    private var isLiked: Bool = false {
        didSet {
            updateLikeButton()
        }
    }

    private func updateLikeButton() {
        let imageName = isLiked ? "heart" : "heart.fill"
        let tintColor = isLiked ? UIColor.gray02 : UIColor.red00
        postDetailView.likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        postDetailView.likeButton.tintColor = tintColor
    }

    private var postImages: [String] = []
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        socialPostService.getPostDetailsFromServer(postId: postId!, token: token){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    if let postDetail = response.result {
                        print("게시글 조회 성공")
                                                
                        self.postImages.append(contentsOf: postDetail.postImageList.compactMap { $0 })
                        self.isLiked = postDetail.isLiked
                        isLiked.toggle()
 
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
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        socialPostService.likePostToServer(postId: postId!, token: token){ [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if response.isSuccess {
                    if response.message == "성공입니다." {
                        print("게시글 좋아요 성공")
                        isLiked.toggle()
                        fetchPostDetailsFromServer()
                    }
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("게시글 좋아요 실패: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func postSettingButton() {
        let handler: UIActionHandler = { [weak self] action in
            guard let self else { return }

            switch action.title {
            case "수정":
                let modifyVC = ModifyPostViewController()
                modifyVC.postId = self.postId
                self.navigationController?.pushViewController(modifyVC, animated: true)
            case "신고":
                self.reportPost()
            case "삭제":
                self.deletePost()
            default:
                break
            }
        }
        
        let modifyAction = makeAction(title: "수정", color: .gray00, handler: handler)
        let reportAction = makeAction(title: "신고", color: .gray00, handler: handler)
        let deleteAction = makeAction(title: "삭제", color: .red00, handler: handler)

        let menu = UIMenu(options: .displayInline, children: [modifyAction, reportAction, deleteAction])
        postDetailView.postSetting.menu = menu
        postDetailView.postSetting.showsMenuAsPrimaryAction = true
    }
    
    
    private func reportPost() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {  return  }
        
        socialPostService.reportPostToServer(postId: postId!, token: token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if response.isSuccess {
                    if response.message == "성공입니다." {
                        print("게시글 신고 성공")
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("게시글 신고 실패: \(error.localizedDescription)")
            }
        }
        
        
    }
    
    private func deletePost() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {  return  }
        
        socialPostService.deletePostToServer(postId: postId!, token: token) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if response.isSuccess {
                    if response.message == "성공입니다." {
                        print("게시글 삭제 성공")
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("게시글 좋아요 실패: \(error.localizedDescription)")
            }
        }
    }
}


// 게시글 이미지에 대한 scrollView
extension PostDetailViewController: UIScrollViewDelegate {
    func contentScrollView() {
        postDetailView.postImageScrollView.layoutIfNeeded()

        for i in 0..<postImages.count {
            let imageView = UIImageView()
            let positionX = postDetailView.postImageScrollView.frame.width * CGFloat(i)

            imageView.frame = CGRect(x: positionX, y: 0, width: postDetailView.postImageScrollView.frame.width, height: postDetailView.postImageScrollView.frame.height)
            imageView.contentMode = .scaleAspectFit

            //  String → URL 변환 후 SDWebImage로 이미지 비동기 로드
            if let url = URL(string: postImages[i]) {
                imageView.sd_setImage(with: url)
            }

            postDetailView.postImageScrollView.addSubview(imageView)

        }
        
        // 전체 컨텐츠 크기를 설정하여 스크롤을 가능하게 만듦
        postDetailView.postImageScrollView.contentSize = CGSize(width: postDetailView.postImageScrollView.frame.width * CGFloat(postImages.count), height: postDetailView.postImageScrollView.frame.height)
        
        // 페이지 컨트롤 설정
        postDetailView.postImagePageControl.numberOfPages = postImages.count
        postDetailView.postImagePageControl.currentPage = 0
        
        // 이미지가 1개면 pageControl 숨김
        postDetailView.postImagePageControl.isHidden = postImages.count == 1 ? true : false
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
