//
//  PostDetailView.swift.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/23/25.
//

import UIKit
import SnapKit
import Then

class PostDetailView: UIView {
    
    public lazy var navigationBar = CustomNavigationBar()

    private let topLeftView = UIView().then { view in
    }
    
    public lazy var accountImageView = UIImageView().then { imageView in
        imageView.image = UIImage(named: "testImage")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    public lazy var accountName = UILabel().then { label in
        label.text = "샌디치먹고싶어"
        label.font = UIFont(name: "Pretendard-Bold", size: 13)
        label.textColor = .gray00
    }
    
    public lazy var postCategory = UILabel().then { label in
        label.text = "Q&A"
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = .brown00
    }
    
    public lazy var postSetting = UIButton().then { button in
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .gray01
    }
    
    public lazy var postTitle = UILabel().then { label in
        label.text = "간식 추천받아요"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = UIColor.gray00
        label.textAlignment = .left
    }
    
    public lazy var postContent = UILabel().then { label in
        label.text = "주인이 뺏어먹어도 될 정도로 진짜 맛있는걸루 ,, 그럼 빵맛이 나는 간식은 없을까요 ????? 없겠지 ㅜㅜ 만약에 혹시나도 있으면 땅버맛으로 부탁할게요"
        label.font = UIFont(name: "Pretendard-Regular", size: 13)
        label.textAlignment = .left
        label.textColor = .gray00
        label.numberOfLines = 2
        label.setLineSpacing(lineSpacing: 5)
    }
    
    public lazy var postImageScrollView = UIScrollView().then { scrollView in
        scrollView.layer.cornerRadius = 10
        scrollView.clipsToBounds = true
        scrollView.isPagingEnabled = true
    }
    
    public lazy var postImagePageControl = UIPageControl().then { pageControl in
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = .gray04
        pageControl.currentPageIndicatorTintColor = .blue01
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
    }


    public lazy var likeButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .gray01
        button.isUserInteractionEnabled = true
    }
    
    public lazy var likeCount = setSubLabel(title: "375")
    
    public lazy var commentButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "ellipsis.message"), for: .normal)
        button.tintColor = .gray01
        button.isEnabled = true
        button.isUserInteractionEnabled = true
    }
    
    public lazy var commentCount = setSubLabel(title: "10")
    
    public lazy var postTimeLabel = UILabel().then { label in
        label.text = "6시간 전"
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .gray01
        label.textAlignment = .right
    }
    
    private func setSubLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .gray01
    
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.isUserInteractionEnabled = true
        setCustomNavigationBarConstraints()
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setCustomNavigationBarConstraints() {
        self.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    
    private func addComponents() {
        self.addSubview(topLeftView)
        topLeftView.addSubview(accountImageView)
        topLeftView.addSubview(accountName)
        topLeftView.addSubview(postCategory)
        
        topLeftView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(25)
            make.height.equalTo(40)
        }
        
        accountImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        accountName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(3)
            make.leading.equalTo(accountImageView.snp.trailing).offset(10)
        }
        
        postCategory.snp.makeConstraints { make in
            make.leading.equalTo(accountName)
            make.bottom.equalToSuperview().inset(3)
        }
        
        self.addSubview(postSetting)
        postSetting.snp.makeConstraints { make in
            make.centerY.equalTo(topLeftView)
            make.width.equalTo(24)
            make.height.equalTo(22)
            make.trailing.equalToSuperview().inset(25)
        }
        
        self.addSubview(postTitle)
        self.addSubview(postContent)
        self.addSubview(postImageScrollView)
        self.addSubview(postImagePageControl)
        
        postTitle.snp.makeConstraints { make in
            make.leading.equalTo(topLeftView)
            make.top.equalTo(topLeftView.snp.bottom).offset(20)
        }
        
        postContent.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(postTitle.snp.bottom).offset(10)
        }
        
        postImageScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(postContent.snp.bottom).offset(20)
            make.height.equalTo(postImageScrollView.snp.width) // width와 height를 같게 설정
        }
        
        postImagePageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(postImageScrollView.snp.bottom).offset(5)
        }
        
        self.addSubview(likeButton)
        self.addSubview(likeCount)
        self.addSubview(commentButton)
        self.addSubview(commentCount)
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(topLeftView)
            make.top.equalTo(postImageScrollView.snp.bottom).offset(20)
            make.width.height.equalTo(24)
        }
        
        likeCount.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(3)
            make.centerY.equalTo(likeButton)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(likeButton)
            make.leading.equalTo(likeCount.snp.trailing).offset(10)
            make.width.height.equalTo(24)
        }
        
        commentCount.snp.makeConstraints { make in
            make.leading.equalTo(commentButton.snp.trailing).offset(3)
            make.centerY.equalTo(commentButton)
        }
        
        
        self.addSubview(postTimeLabel)
        
        postTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalTo(likeButton)
        }
        
    }
}
