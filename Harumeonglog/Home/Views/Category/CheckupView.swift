//
//  CheckupView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/14/25.
//

import UIKit
import SnapKit

class CheckupView: UIView {
    
    let hospitalLabel : UILabel = {
        let label = UILabel()
        label.text = "병원"
        label.font = .body
        label.textColor = .gray00
        return label
    }()
    
    lazy var hospitalTextField: UITextField = {
        let textField = UITextField()
        textField.font = .body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown02.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    let departmentLabel : UILabel = {
        let label = UILabel()
        label.text = "진료과목"
        label.font = .body
        label.textColor = .gray00
        return label
    }()
    
    lazy var departmentTextField: UITextField = {
        let textField = UITextField()
        textField.font = .body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown02.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    let costLabel : UILabel = {
        let label = UILabel()
        label.text = "병원비"
        label.font = .body
        label.textColor = .gray00
        return label
    }()
    
    lazy var costTextField: UITextField = {
        let textField = UITextField()
        textField.font = .body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown02.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel()
        label.text = "세부 내용"
        label.font = .body
        label.textColor = .gray00
        return label
    }()
    
    lazy var detailTextField: UITextField = {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "세부내용을 입력하세요.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray02]
        )

        textField.font = .body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown02.cgColor
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

        self.addSubview(hospitalLabel)
        self.addSubview(hospitalTextField)
        self.addSubview(departmentLabel)
        self.addSubview(departmentTextField)
        self.addSubview(costLabel)
        self.addSubview(costTextField)
        self.addSubview(detailLabel)
        self.addSubview(detailTextField)
        
        hospitalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        
        hospitalTextField.snp.makeConstraints { make in
            make.top.equalTo(hospitalLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(362)
            make.height.equalTo(45)
        }
        
        departmentLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        departmentTextField.snp.makeConstraints { make in
            make.top.equalTo(departmentLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(170)
            make.height.equalTo(45)
        }
        
        costLabel.snp.makeConstraints { make in
            make.top.equalTo(departmentLabel.snp.top)
            make.leading.equalTo(departmentTextField.snp.trailing).offset(32)
            make.height.equalTo(16)
        }
        costTextField.snp.makeConstraints { make in
            make.top.equalTo(departmentTextField.snp.top)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(170)
            make.height.equalTo(45)
        }

        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(costTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        detailTextField.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(10)
            make.width.equalTo(362)
            make.height.equalTo(126)
            make.centerX.equalToSuperview()
        }
    }
}
