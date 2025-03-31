//
//  BathView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/14/25.
//

import UIKit
import SnapKit

class BathView: UIView {

    let detailLabel : UILabel = {
        let label = UILabel()
        label.text = "세부 내용"
        label.font = .body
        label.textColor = .gray00
        return label
    }()
    
    lazy var detailTextView: UITextView = {
        let textView = UITextView()
        
        textView.text = "세부내용을 입력하세요." // placeholder
        textView.textColor = .gray02 // placeholder 색상
        textView.font = .body
        textView.backgroundColor = .white
        textView.layer.borderColor = UIColor.brown02.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 15
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 10) // 패딩

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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "세부내용을 입력하세요." {
            textView.text = ""
            textView.textColor = .gray00
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "세부내용을 입력하세요."
            textView.textColor = .gray02
        }
    }
}

