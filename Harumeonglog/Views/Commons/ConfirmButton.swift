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

