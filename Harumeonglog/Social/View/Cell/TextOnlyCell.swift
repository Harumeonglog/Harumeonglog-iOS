//
//  TextOnlyCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/23/25.
//

import UIKit
import SnapKit
import Then

// MARK: 소셜 조회에서 이미지가 없는 경우
class TextOnlyCell: UITableViewCell {
    
    static let identifier = "TextOnlyCell"
    
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
        label.text = "주인이 뺏어먹어도 될 정도로 진짜 맛있는걸루 ,, 그럼 빵맛이 나는 간식이 있을까요 ????? 없겠지 ㅜㅜ 만약에 혹시나도 있으면 땅버맛으로 부탁할게요"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textAlignment = .left
        label.textColor = .gray00
        label.numberOfLines = 1
        label.setLineSpacing(lineSpacing: 3)
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
            make.leading.trailing.equalToSuperview().inset(27.5)
            make.width.equalTo(230)
        }
        
        self.addSubview(underlineView)
        

        underlineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(22.5)
            make.height.equalTo(1)
        }
        
        
    }
    
    func configure(with post: PostItem) {
        categoryLabel.text = post.postCategory
        titleLabel.text = post.title
        contentLabel.text = post.content
        likeCountLabel.text = "\(post.likeNum)"
        postTime.text = timeAgoString(from: post.createdAt!)
    }
    
    
    func timeAgoString(from createdAtString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 9 * 3600) // KST 기준으로 파싱

        guard let createdAt = formatter.date(from: createdAtString) else {
            return "알 수 없음"
        }

        let now = Date()
        let interval = now.timeIntervalSince(createdAt)

        if interval < 60 {
            return "\(Int(interval))초 전"
        } else if interval < 3600 {
            return "\(Int(interval / 60))분 전"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))시간 전"
        } else {
            return "\(Int(interval / 86400))일 전"
        }
    }




}
