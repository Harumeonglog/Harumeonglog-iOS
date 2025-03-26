//
//  ReplyCommentTableViewCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/24/25.
//

import UIKit
import SnapKit
import Then

class ReplyCommentTableViewCell: UITableViewCell {
    
    static let identifer = "ReplyCommentTableViewCell"
    
    public lazy var arrowTurnDown = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "arrow.turn.down.right")
        imageView.tintColor = .gray00
    }
    
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
        label.textAlignment = .left
    }
    
    public lazy var postTime = UILabel().then { label in
        label.text = "1시간 전"
        label.font = UIFont(name: "Pretendard-Regular", size: 10)
        label.textColor = .gray02
        label.textAlignment = .left
    }
    
    public lazy var commentSetting = UIButton().then { button in
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .gray01
    }
    
    public lazy var commentContent = UILabel().then { label in
        label.text = "와~ 저도 참고해야겠어요 간식 추천 감사합니다~!"
        label.font = UIFont(name: "Pretendard-Regular", size: 13)
        label.textAlignment = .left
        label.textColor = .gray00
        label.numberOfLines = 2
        label.setLineSpacing(lineSpacing: 5)
    }
    
    public lazy var replyButton = UIButton().then { button in
        button.setTitle("답글 달기", for: .normal)
        button.setTitleColor(UIColor.gray02, for: .normal)
        button.backgroundColor = .background
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 10)
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
        self.addSubview(arrowTurnDown)
        
        arrowTurnDown.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(40)
            make.width.height.equalTo(16)
        }
        
        self.addSubview(topLeftView)
        topLeftView.addSubview(accountImageView)
        topLeftView.addSubview(accountName)
        topLeftView.addSubview(postTime)
        
        topLeftView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(arrowTurnDown.snp.trailing).offset(12)
            make.height.equalTo(40)
        }
        
        accountImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        accountName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.leading.equalTo(accountImageView.snp.trailing).offset(10)
        }
        
        postTime.snp.makeConstraints { make in
            make.leading.equalTo(accountName)
            make.bottom.equalToSuperview().inset(4)
        }
        
        self.addSubview(commentSetting)
        commentSetting.snp.makeConstraints { make in
            make.centerY.equalTo(topLeftView)
            make.width.equalTo(24)
            make.height.equalTo(22)
            make.trailing.equalToSuperview()
        }
        
        self.addSubview(commentContent)
        self.addSubview(replyButton)
        
        commentContent.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(90)
            make.top.equalTo(topLeftView.snp.bottom).offset(5)
            make.trailing.equalTo(commentSetting.snp.leading)
        }
        
        replyButton.snp.makeConstraints { make in
            make.top.equalTo(commentContent.snp.bottom)
            make.leading.equalTo(commentContent)
        }
        
    }
}
