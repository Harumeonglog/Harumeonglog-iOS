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
        $0.image = UIImage(named: "defaultImage")
        $0.contentMode = .scaleAspectFit
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
        self.backgroundColor = .background
        setUI()
        self.myImageView.kf.setImage(with: URL(string: MemberAPIService.userInfo?.image ?? ""), placeholder: UIImage(named: "defaultImage"))
        self.myNameLabel.text = MemberAPIService.userInfo?.nickname
        self.comment = comment
        self.timeLabel.text = timeAgoString(from: comment.createdAt)
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
        
        // 텍스트 라인 높이 설정
        setupTextLineHeight()
    }
    
    private let lineHeight: CGFloat = 16 // 라인당 16 CGFloat
    
    private func setupTextLineHeight() {
            guard let text = contentLabel.text, !text.isEmpty else { return }
            
            // NSAttributedString으로 라인 높이 설정
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight - contentLabel.font.lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.count))
            attributedString.addAttribute(.font, value: contentLabel.font ?? UIFont.systemFont(ofSize: 13), range: NSRange(location: 0, length: text.count))
            
            contentLabel.attributedText = attributedString
        }
        
        // 셀 높이 계산 메서드
        func calculateCellHeight() -> CGFloat {
            guard let text = contentLabel.text, !text.isEmpty else {
                return 90 // 기본 높이
            }
            
            let font = contentLabel.font ?? UIFont.systemFont(ofSize: 13)
            let textWidth = UIScreen.main.bounds.width - 40 - distanceFromImage - 16 // 이미지 너비 + 여백
            
            let textHeight = text.height(withConstrainedWidth: textWidth, font: font, lineHeight: lineHeight)
            
            return max(90, 60 + textHeight) // 최소 높이 보장
        }
        
        // 셀 재사용 방지를 위한 초기화
        override func prepareForReuse() {
            super.prepareForReuse()
            
            // 모든 상태 초기화
            myImageView.image = nil
            myNameLabel.text = nil
            timeLabel.text = nil
            contentLabel.text = nil
            contentLabel.attributedText = nil
            comment = nil
            
            // 이미지 로딩 취소 (Kingfisher 사용 시)
            myImageView.kf.cancelDownloadTask()
        }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont, lineHeight: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - font.lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        
        let numberOfLines = Int(ceil(boundingBox.height / lineHeight))
        return CGFloat(numberOfLines) * lineHeight
    }
}
