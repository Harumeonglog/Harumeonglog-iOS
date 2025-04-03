//
//  PostDetailViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/24/25.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    private var isLiked: Bool = false
    private var photos = [UIImage(named:"testImage"), UIImage(named: "testImage"), UIImage(named: "testImage")]


    private lazy var postDetailView: PostDetailView = {
        let view = PostDetailView()
        view.backgroundColor = .background
        
        view.postImageScrollView.delegate = self
        // view.postSetting.addTarget(self, action: #selector(postSettingTapped), for: .touchUpInside)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentScrollView()
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = postDetailView.navigationBar
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc func postSettingTapped() {
        
    }
    
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func commentButtonTapped() {
        let commentVC = CommentViewController()
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
            if action.title == "삭제" {
                
            }
        }
        
        let deleteTitle = NSAttributedString(
            string: "삭제",
            attributes: [
                .foregroundColor: UIColor.red00,
                .font: UIFont.headline
            ]
        )
        
        let deleteAction = UIAction(title: "", handler: popUpButtonClosure)
        deleteAction.setValue(deleteTitle, forKey: "attributedTitle") // 삭제 버튼의 색상을 변경

        let menu = UIMenu(options: .displayInline, children: [deleteAction]) // 메뉴 크기 줄이기
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
