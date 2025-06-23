//
//  RecommendRouteViewCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/17/25.
//

import UIKit
import Then

protocol RecommendRouteTableViewCellDelegate: AnyObject {
    func likeButtonTapped(in: RecommendRouteTableViewCell)
}

class RecommendRouteTableViewCell: UITableViewCell {
    
    static let identifier = "RecommendRouteTableViewCell"
    
    weak  var delegate: RecommendRouteTableViewCellDelegate?
    
    public lazy var titleLabel = UILabel().then { label in
        label.text = "상명대에서 경복궁까지"
        label.textColor = UIColor.gray00
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-Mdeium", size: 15)
    }
    
    private lazy var leftContainer = UIView().then { view in
    }
    public lazy var userLabel = commonTextColorFont(text: "크크님의 산책로")
    
    
    public lazy var likeButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.tintColor = UIColor.gray01
        button.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
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
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }

    private func addComponents() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(leftContainer)
        leftContainer.addSubview(userLabel)
        leftContainer.addSubview(likeButton)
        leftContainer.addSubview(likeCountLabel)
        
        leftContainer.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.width.greaterThanOrEqualTo(110)
        }
        
        userLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(userLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(2)
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
            make.trailing.equalTo(distanceLabel.snp.leading).offset(-10)
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
    
    @objc private func likeButtonTapped() {        
        delegate?.likeButtonTapped(in: self)
    }
    
    var isLiked: Bool = false {
        didSet {
            updateLikeButton()
        }
    }
    

    private func updateLikeButton() {
        let imageName = isLiked ? "hand.thumbsup.fill" : "hand.thumbsup"
        // let color = isLiked ? UIColor.red01 : UIColor.gray01
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.tintColor = UIColor.gray01
    }
    
    func configure(with route: WalkRecommendItem) {
        titleLabel.text = route.title
        likeCountLabel.text = "\(route.walkLikeNum)"
        distanceLabel.text = route.distance
        timeLabel.text = "\(route.time)분"
        userLabel.text = "\(route.memberNickname) 님의 산책로"
        isLiked = route.isLike
        
    }
}
