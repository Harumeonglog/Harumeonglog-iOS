//
//  InviteUser.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/6/25.
//

import UIKit

class InviteUserView: UIView {
    
    private lazy var searchTextField = UITextField().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        
        $0.backgroundColor = .white
        $0.tintColor = .gray02
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.brown02.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        addConstraints()
    }
    
    private func addConstraints() {
        self.addSubview(searchTextField)
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(31)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        addLeftViewInTextField()
    }
    
    private func addLeftViewInTextField() {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 30))
        
        let searchIcon = UIImageView().then {
            $0.image = .search
            $0.contentMode = .scaleAspectFit
        }
        
        searchTextField.addSubview(searchIcon)
        
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        searchTextField.leftView = leftView
        searchTextField.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

import SwiftUI
#Preview {
    InviteUserViewController()
}
