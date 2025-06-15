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
        label.font = .body
        label.textColor = .gray00
        return label
    }()
    
    lazy var distanceTextField: UITextField = {
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
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "소요시간 (분)"
        label.font = .body
        label.textColor = .gray00
        return label
    }()
    
    lazy var timeTextField: UITextField = {
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
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "산책 후 데이터를 기록하세요!"
        label.font = .description
        label.textColor = .brown00
        return label
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

        self.addSubview(distanceLabel)
        self.addSubview(distanceTextField)
        self.addSubview(timeLabel)
        self.addSubview(timeTextField)
        self.addSubview(descriptionLabel)
        self.addSubview(detailLabel)
        self.addSubview(detailTextView)

        distanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(16)
        }
        distanceTextField.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(170)
            make.height.equalTo(45)
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
            make.height.equalTo(45)
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
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(10)
            make.width.equalTo(362)
            make.height.equalTo(126)
            make.centerX.equalToSuperview()
        }
    }
}

//MARK: 사용자가 입력한 세부 내용을 가져오는 메서드
extension WalkView  {
    func getInput() -> (distance: String, duration: String, details: String){
        return (
            distance: distanceTextField.text ?? "",
            duration: timeTextField.text ?? "",
            details: detailTextView.text ?? ""
        )
    }
}

//MARK: 서버에서 받은 일정 데이터를 UI에 반영
extension WalkView: EventDetailReceivable {
    func applyContent(from data: EventDetailData) {
        distanceTextField.text = data.fields["distance"]
        timeTextField.text = data.fields["time"]
        detailTextView.text = data.fields["detail"]
    }
}
