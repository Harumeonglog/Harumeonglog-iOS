//
//  MyCommentCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit
import Kingfisher

class MyCommentCell: UITableViewCell {
    
    static let identifier: String = "MyCommentCell"
    private var comment: MyCommentItem?
    private var distanceFromImage: CGFloat = 8
    
    private lazy var myImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.kf.setImage(with: URL(string: MemberAPIService.userInfo?.image ?? ""))
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private lazy var myNameLabel = UILabel().then {
        $0.font = UIFont(name: FontName.pretendard_bold.rawValue, size: 13)
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    private lazy var timeLabel = UILabel().then{
        $0.font = UIFont(name: FontName.pretendard_light.rawValue, size: 10)
        $0.textColor = .gray02
        $0.textAlignment = .left
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 4
        $0.font = UIFont(name: FontName.pretendard_light.rawValue, size: 13)
        $0.textColor = .gray00
    }
    
    func configure(comment: MyCommentItem) {
        self.comment = comment
        self.timeLabel.text = timeAgoString(from: DateFormatterShared.convertISO8601StringToDate(comment.createdAt) ?? .now)
        self.contentLabel.text = comment.content
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUI() {
        self.addSubview(myImageView)
        self.addSubview(myNameLabel)
        self.addSubview(timeLabel)
        self.addSubview(contentLabel)
        
        myImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.top.equalToSuperview()
        }
        
        myNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(myImageView.snp.trailing).offset(distanceFromImage)
            make.top.equalTo(myImageView).offset(4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(myImageView.snp.trailing).offset(distanceFromImage)
            make.top.equalTo(myNameLabel.snp.bottom).offset(2)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(myImageView.snp.trailing).offset(distanceFromImage)
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
        }
    }
    
}
