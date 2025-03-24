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
        label.font = K.Font.body
        label.textColor = .gray00
        return label
    }()
    
    lazy var medicineNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = K.Font.body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown01.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    let medicineDosageLabel : UILabel = {
        let label = UILabel()
        label.text = "복용량"
        label.font = K.Font.body
        label.textColor = .gray00
        return label
    }()
    
    lazy var medicineDosageTextField: UITextField = {
        let textField = UITextField()
        textField.font = K.Font.body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown01.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        return textField
    }()
    
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
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown01.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15

        return textField
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
        self.addSubview(medicineDosageLabel)
        self.addSubview(medicineDosageTextField)
        self.addSubview(detailLabel)
        self.addSubview(detailTextField)

        medicineNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        medicineNameTextField.snp.makeConstraints { make in
            make.top.equalTo(medicineNameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(170)
            make.height.equalTo(40)
        }
        
        medicineDosageLabel.snp.makeConstraints { make in
            make.top.equalTo(medicineNameLabel.snp.top)
            make.leading.equalTo(medicineNameTextField.snp.trailing).offset(32)
            make.height.equalTo(16)
        }
        medicineDosageTextField.snp.makeConstraints { make in
            make.top.equalTo(medicineNameTextField.snp.top)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(170)
            make.height.equalTo(40)
        }

        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(medicineDosageTextField.snp.bottom).offset(20)
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
