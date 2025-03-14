//
//  Untitled.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/14/25.
//
import UIKit
import SnapKit

class MedicineView: UIView {
    
    private let medicineNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "복용할 약 이름 입력"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let dosageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "복용량 입력"
        textField.borderStyle = .roundedRect
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
        let stackView = UIStackView(arrangedSubviews: [medicineNameTextField, dosageTextField])
        stackView.axis = .vertical
        stackView.spacing = 12
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
}
