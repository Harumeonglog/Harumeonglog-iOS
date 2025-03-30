//
//  RecommendRouteViewCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/17/25.
//

import UIKit
import Then

class RecommendRouteTableViewCell: UITableViewCell {
    
    static let identifier = "RecommendRouteTableViewCell"
    
    public lazy var titleLabel = UILabel().then { label in
        label.text = "상명대에서 경복궁까지"
        label.textColor = UIColor.gray00
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-Mdeium", size: 15)
    }
    
    private lazy var leftContainer = UIView().then { view in
    }
    public lazy var userLabel = commonTextColorFont(text: "크크님의 산책로")
    private lazy var thumbsUpImageView = UIImageView().then { imageView in
        imageView.image = UIImage(named: "thumbsUp")
        imageView.frame.size = CGSize(width: 15, height: 15)
    }
    public lazy var likeCountLabel = commonTextColorFont(text: "123")
    
    
    
    private lazy var rightContainer = UIView().then { view in
        view.contentMode = .left
    }
    public lazy var timeLabel = commonTextColorFont(text: "35분")
    public lazy var distanceLabel = commonTextColorFont(text: "4.5km")
    
    private lazy var separatorView = UIView().then { view in
        view.backgroundColor = UIColor.gray04
    }
    
    
    private func commonTextColorFont(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.gray01
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        return label
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.background
        self.addComponents()
    }
    

    private func addComponents() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
        }
        
        self.addSubview(leftContainer)
        leftContainer.addSubview(userLabel)
        leftContainer.addSubview(thumbsUpImageView)
        leftContainer.addSubview(likeCountLabel)
        
        leftContainer.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.greaterThanOrEqualTo(110)
        }
        
        userLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        thumbsUpImageView.snp.makeConstraints { make in
            make.leading.equalTo(userLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbsUpImageView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(rightContainer)
        rightContainer.addSubview(timeLabel)
        rightContainer.addSubview(distanceLabel)
        
        rightContainer.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(leftContainer)
            make.width.greaterThanOrEqualTo(110)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(distanceLabel.snp.leading).offset(-15)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
        }
        
        
        self.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
