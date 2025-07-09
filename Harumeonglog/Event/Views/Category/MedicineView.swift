//
//  Untitled.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/14/25.
//
import UIKit
import SnapKit

class MedicineView: UIView {
    
    let medicineNameLabel : UILabel = {
        let label = UILabel()
        label.text = "복용약"
        label.font = .body
        label.textColor = .gray00
        return label
    }()
    
    lazy var medicineNameTextField: UITextField = {
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
        self.isUserInteractionEnabled = true
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {

        self.addSubview(medicineNameLabel)
        self.addSubview(medicineNameTextField)
        self.addSubview(detailLabel)
        self.addSubview(detailTextView)

        medicineNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        medicineNameTextField.snp.makeConstraints { make in
            make.top.equalTo(medicineNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }

        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(medicineNameTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(126)
            make.centerX.equalToSuperview()
        }
    }
}

//MARK: 사용자가 입력한 세부 내용을 가져오는 메서드
extension MedicineView {
    func getInput() -> (medicineName: String, details: String ){
        let name = medicineNameTextField.text ?? ""
        let detail = detailTextView.text ?? ""
        print("getInput() 호출됨 — name: '\(name)', details: '\(detail)'")
        return (medicineName: name, details: detail)
    }
    
}

//MARK: 서버에서 받은 일정 데이터를 UI에 반영
extension MedicineView: EventDetailReceivable {
    func applyContent(from data: EventDetailData) {
        medicineNameTextField.text = data.fields["medicineName"]
        detailTextView.text = data.fields["detail"]
    }
}
