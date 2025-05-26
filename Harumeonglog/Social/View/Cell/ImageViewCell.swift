//
//  ImageViewCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/23/25.
//

import UIKit
import SnapKit
import Then

// MARK: 소셜 조회에서 이미지가 있는 경우
class ImageViewCell: UITableViewCell {
    
    static let identifier = "ImageViewCell"
    
    private lazy var contentStackView = UIStackView().then { stackView in
        let subContentStackView = UIStackView(arrangedSubviews: [likeImageView, likeCountLabel, dotLabel, postTime])
        subContentStackView.axis = .horizontal
        subContentStackView.spacing = 2
        subContentStackView.alignment = .firstBaseline
        
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(subContentStackView)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .leading
    }
    
    public lazy var categoryLabel = UILabel().then { label in
        label.text = "Q&A"
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textAlignment = .left
        label.textColor = .brown00
    }
    
    public lazy var titleLabel = UILabel().then { label in
        label.text = "간식 추천받아요"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textAlignment = .left
        label.textColor = .gray00
    }
    
    public lazy var contentLabel = UILabel().then { label in
        label.text = "주인이 뺏어먹어도 될 정도로 진짜 맛있는걸루 ,, 그럼 빵맛이 나는 간식이 있을까요 ????? 없겠지 ㅜㅜ"
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textAlignment = .left
        label.textColor = .gray01
        label.numberOfLines = 1
        // label.setLineSpacing(lineSpacing: 3)
    }
    
    public lazy var likeImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = .gray02
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
    }
    
    public lazy var likeCountLabel = setSubLabel(title: "375")
    
    private lazy var dotLabel = setSubLabel(title: " · ")
    
    public lazy var postTime = setSubLabel(title: "12분 전")
    
    private func setSubLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Pretendard-Regular", size: 11)
        label.textColor = .gray01
    
        return label
    }
    
    public lazy var postImageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "testImage")
    }
    
    private lazy var underlineView = UIView().then { view in
        view.backgroundColor = .gray03
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .background
        self.addComponents()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func addComponents() {
        self.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(27.5)
            make.width.equalTo(230)
        }
        
        self.addSubview(postImageView)
        self.addSubview(underlineView)
        
        postImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalTo(contentStackView)
            make.trailing.equalToSuperview().inset(27.5)
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(22.5)
            make.height.equalTo(1)
        }
        
    }
    
    
    func configure(with post: PostItem) {
        categoryLabel.text = socialCategoryKey.tagsEngKorto[post.postCategory]
        titleLabel.text = post.title
        contentLabel.text = post.content
        likeCountLabel.text = "\(post.likeNum)"
        postTime.text = timeAgoString(from: post.createdAt!)
        postImageView.sd_setImage(with: URL(string: post.imageKeyName!))
    }
}
