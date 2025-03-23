//
//  PopupView.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class BinarySelectionPopupView: UIView {
    
    public lazy var mainFrame = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    public lazy var mainTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private lazy var divider = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    private lazy var buttonStackFrame = UIView()
    
    public lazy var leftButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
    }
    
    public lazy var rightButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.addComponents()
    }
    
    private func addComponents() {
        
        self.addSubview(mainFrame)
        
        mainFrame.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalTo(300)
            make.center.equalToSuperview()
        }
        
        mainFrame.addSubview(mainTitleLabel)
        mainFrame.addSubview(divider)
        mainFrame.addSubview(buttonStackFrame)
        
        mainTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(2)
            make.height.equalTo(1)
            make.top.equalTo(buttonStackFrame.snp.top)
        }
        
        buttonStackFrame.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(12)
        }
        
        buttonStackFrame.addSubview(leftButton)
        buttonStackFrame.addSubview(rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(60)
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(60)
        }
    }
    
    public func configure(title: String, leftButtonText: String, rightButtonText: String) {
        mainTitleLabel.text = title
        leftButton.setTitle(leftButtonText, for: .normal)
        rightButton.setTitle(rightButtonText, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

