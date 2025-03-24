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
        label.font = K.Font.body
        label.textColor = .gray00
        return label
    }()
    
    lazy var detailTextField: UITextField = {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "세부내용을 입력하세요.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray02]
        )

        textField.font = K.Font.body
        textField.textColor = .gray02
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown01.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15

        return textField
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
        self.addSubview(detailTextField)
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        
        detailTextField.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(10)
            make.width.equalTo(362)
            make.height.equalTo(126)
            make.centerX.equalToSuperview()
        }
    }
}

