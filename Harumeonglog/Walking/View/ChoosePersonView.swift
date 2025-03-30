//
//  ChoosePersonView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/30/25.
//

import UIKit
import SnapKit
import Then

class ChoosePersonView: UIView {
    
    private lazy var titleLabel = UILabel().then { label in
        label.text = "누구와 함께하는 산책인가요 ?"
        label.textColor = .gray00
        label.textAlignment = .center
        label.font = .init(name: "Pretendard-Bold", size: 20)
    }
    
    public lazy var chooseCancelBtn = UIButton().then { button in
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray00
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
    
    public lazy var chooseSaveBtn = UIButton().then { button in
        button.setTitle("산책하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 17)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .blue01
        button.layer.cornerRadius = 25
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(550)
        }
        
        self.addSubview(titleLabel)
        self.addSubview(chooseCancelBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        
        chooseCancelBtn.snp.makeConstraints { make in
            make.lastBaseline.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(25)
        }
        
        self.addSubview(chooseSaveBtn)
        
        chooseSaveBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.width.lessThanOrEqualTo(130)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(110)
        }
        
    }
}
