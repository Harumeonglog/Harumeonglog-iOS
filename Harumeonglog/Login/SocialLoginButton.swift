//
//  SocialLoginButton.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/15/25.
//

import UIKit
import SnapKit
import Then

class SocialLoginButton: UIButton {
    
    private lazy var socialLogo = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var mainTitle = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Medium", size: 15)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    private func addComponents() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        self.addSubview(socialLogo)
        self.addSubview(mainTitle)
        
        socialLogo.snp.makeConstraints { make in
            make.height.width.equalTo(18)
            make.leading.equalToSuperview().offset(31.5)
            make.centerY.equalToSuperview()
        }
        
        mainTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func configure(title: String, logog image: UIImage, color: UIColor) {
        mainTitle.text = title
        socialLogo.image = image
        self.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
