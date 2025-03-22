//
//  AlertView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/22/25.
//

import UIKit
import SnapKit
import Then

class AlertView: UIView {
    
    private lazy var titleLabel = UIButton().then { button in
        button.setTitleColor(.gray00, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 17)
        button.titleLabel?.textAlignment = .center
        button.isEnabled = false
    }
    
    private lazy var underlineView = UIView().then { view in
        view.backgroundColor = .gray04
    }
    
    private lazy var btnStackView = UIStackView().then { stackView in
        stackView.addArrangedSubview(cancelBtn)
        stackView.addArrangedSubview(confirmBtn)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
    }
    
    private lazy var cancelBtn = UIButton().then { button in
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.gray01, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 17)
    }
    
    private lazy var confirmBtn = UIButton().then { button in
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 17)
        button.backgroundColor = .red00
    }
    
    
    init(title: String, confirmText: String) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        // 메시지, 확인버튼 text 초기화
        titleLabel.setTitle(title, for: .normal)
        confirmBtn.setTitle(confirmText, for: .normal)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        
        self.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        self.addSubview(titleLabel)
        self.addSubview(underlineView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(btnStackView)
        btnStackView.addSubview(cancelBtn)
        btnStackView.addSubview(confirmBtn)
        
        btnStackView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(underlineView)
            make.height.equalTo(60)
        }
        
    }
    
}
