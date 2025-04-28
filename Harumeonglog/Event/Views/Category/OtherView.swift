//
//  OtherView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/14/25.
//

import UIKit
import SnapKit

class OtherView: UIView {

    let detailLabel : UILabel = {
        let label = UILabel()
        label.text = "세부 내용"
        label.font = .body
        label.textColor = .gray00
        return label
    }()
    
    lazy var detailTextView: UITextView = {
        let textView = UITextView()
        
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10

        let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.body,
                .foregroundColor: UIColor.gray00
        ]
        textView.typingAttributes = attributes
        textView.attributedText = NSAttributedString(string: "", attributes: attributes)
        textView.backgroundColor = .white
        textView.layer.borderColor = UIColor.brown02.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 15
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 23)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(detailLabel)
        self.addSubview(detailTextView)
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(10)
            make.width.equalTo(362)
            make.height.equalTo(126)
            make.centerX.equalToSuperview()
        }
    }
}

extension OtherView: EventDetailReceivable {
    func applyContent(from data: EventDetailData) {
        detailTextView.text = data.fields["detail"]
    }
}

