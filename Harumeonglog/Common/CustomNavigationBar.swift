//
//  CustomNavigationBar.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/17/25.
//

import UIKit

class CustomNavigationBar: UIView {
    
    public lazy var leftArrowButton = UIButton().then {
        $0.setImage(.leftArrow, for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var maintitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
    }
    
    public lazy var rightButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.titleLabel?.font = .systemFont(ofSize: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        setConstraints()
    }
    
    private func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        self.addSubview(leftArrowButton)
        self.addSubview(maintitleLabel)
        self.addSubview(rightButton)
        rightButton.isHidden = true
        
        maintitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        
        leftArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(maintitleLabel)
            make.leading.equalToSuperview().offset(11)
            make.top.bottom.equalToSuperview()
            make.height.width.equalTo(44)
        }
        
        leftArrowButton.imageView?.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(12)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalTo(maintitleLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.height.width.equalTo(44)
        }
        
        rightButton.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    public func configureTitle(title: String) {
        maintitleLabel.text = title
    }
    
    public func configureRightButton() {
        rightButton.isHidden = false
    }
    
    public func configureRightButton(text: String) {
        rightButton.isHidden = false
        rightButton.setTitle(text, for: .normal)
        rightButton.setTitleColor(.gray00, for: .normal)
    }

    
    public func changeLeftButton() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

import SwiftUI
#Preview {
    EditProfileViewController()
}
