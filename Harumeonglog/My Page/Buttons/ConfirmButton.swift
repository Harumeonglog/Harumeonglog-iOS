//
//  ConfirmButton.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/18/25.
//

import UIKit

class ConfirmButton: UIButton {
    
    private lazy var mainLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .headline2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = .gray02
        self.isEnabled = false
        addComponents()
    }
    
    private func addComponents() {
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        self.addSubview(mainLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func configure(labelText: String) {
        mainLabel.text = labelText
    }
    
    public func addPlusImage() {
        let plusImage = UIImageView()
        plusImage.image = .whitePlus
        
        mainLabel.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(8.5)
        }
        
        self.addSubview(plusImage)
        plusImage.snp.makeConstraints { make in
            make.height.width.equalTo(14)
            make.centerY.equalTo(mainLabel)
            make.trailing.equalTo(mainLabel.snp.leading).offset(-10)
        }
    }
    
    public func availableForSendQuery() {
        self.backgroundColor = .gray02
        self.isEnabled = true
    }
    
    public func available() {
        self.backgroundColor = .blue01
        self.isEnabled = true
    }
    
    public func unavailable() {
        self.backgroundColor = .gray02
        self.isEnabled = false
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
