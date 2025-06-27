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
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0))
        textField.leftViewMode = .always
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
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    let costLabel : UILabel = {
        let label = UILabel()
        label.text = "병원비 (원)"
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
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
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

        self.addSubview(hospitalLabel)
        self.addSubview(hospitalTextField)
        self.addSubview(departmentLabel)
        self.addSubview(departmentTextField)
        self.addSubview(costLabel)
        self.addSubview(costTextField)
        self.addSubview(detailLabel)
        self.addSubview(detailTextView)
        
        hospitalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        
        hospitalTextField.snp.makeConstraints { make in
            make.top.equalTo(hospitalLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        departmentLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        departmentTextField.snp.makeConstraints { make in
            make.top.equalTo(departmentLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(costTextField.snp.leading).offset(-32)
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
            make.top.equalTo(costTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(126)
        }
    }
}

//MARK: 사용자가 입력한 세부 내용을 가져오는 메서드
extension CheckupView {
    func getInput() -> (hospitalName: String, department: String, cost: String, details: String){
        return (
            hospitalName: hospitalTextField.text ?? "",
            department: departmentTextField.text ?? "",
            cost: costTextField.text ?? "",
            details: detailTextView.text ?? ""
        )
    }
}

//MARK: 서버에서 받은 일정 데이터를 UI에 반영
extension CheckupView: EventDetailReceivable {
    func applyContent(from data: EventDetailData) {
        hospitalTextField.text = data.fields["hospital"]
        departmentTextField.text = data.fields["department"]
        costTextField.text = data.fields["cost"]
        detailTextView.text = data.fields["detail"]
    }
}

