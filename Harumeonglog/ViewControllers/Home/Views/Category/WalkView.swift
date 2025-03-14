//
//  WalkView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/14/25.
//
import UIKit
import SnapKit

class WalkView: UIView {
    
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.text = "거리 (km)"
        label.font = K.Font.body
        label.textColor = .gray00
        return label
    }()
    
    lazy var distanceTextField: UITextField = {
        let textField = UITextField()
        textField.font = K.Font.body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown01.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "소요시간 (분)"
        label.font = K.Font.body
        label.textColor = .gray00
        return label
    }()
    
    lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.font = K.Font.body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown01.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "산책 후 데이터를 기록하세요!"
        label.font = K.Font.description
        label.textColor = .brown00
        return label
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

        self.addSubview(distanceLabel)
        self.addSubview(distanceTextField)
        self.addSubview(timeLabel)
        self.addSubview(timeTextField)
        self.addSubview(descriptionLabel)
        self.addSubview(detailLabel)
        self.addSubview(detailTextField)

        distanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        distanceTextField.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(170)
            make.height.equalTo(40)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.top)
            make.leading.equalTo(distanceTextField.snp.trailing).offset(32)
            make.height.equalTo(16)
        }
        timeTextField.snp.makeConstraints { make in
            make.top.equalTo(distanceTextField.snp.top)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(170)
            make.height.equalTo(40)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(timeTextField.snp.bottom).offset(5)
            make.trailing.equalTo(timeTextField.snp.trailing)
            make.height.equalTo(11)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
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
