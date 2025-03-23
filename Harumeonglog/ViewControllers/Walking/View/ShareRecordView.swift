//
//  ShareRecordView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/22/25.
//

import UIKit
import SnapKit
import Then

class ShareRecordView: UIView {
    
    public lazy var shareCancelBtn = UIButton().then { button in
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray00
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
    
    private lazy var titleLabel = UILabel().then { label in
        label.text = "오늘의 산책을\n공유해주세요 !"
        label.textColor = UIColor.gray01
        label.numberOfLines = 2
        label.font = UIFont(name: "Pretendard-Bold", size: 30)
        label.textAlignment = .center
        label.setLineSpacing(lineSpacing: 10)
    }
    
    private lazy var subtitleLabel = UILabel().then { label in
        label.text = "근처에서 사는 분들과 산책 경로를 공유하고\n 더 즐겁고 다양한 코스를 발견해 보세요 !"
        label.textColor = UIColor.gray02
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-Medium", size: 15)
        label.setLineSpacing(lineSpacing: 15)
    }

    
    public lazy var shareBtn = UIButton().then { button in
        button.setTitle("공유", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 17)
        button.backgroundColor = .blue01
        button.layer.cornerRadius = 25
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(550)
        }
        self.addSubview(shareCancelBtn)
        
        shareCancelBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(51.5)
            make.trailing.equalToSuperview().inset(25)
        }
        
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(shareCancelBtn.snp.bottom).offset(90)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(35)
        }
        
        self.addSubview(shareBtn)
        
        shareBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.width.lessThanOrEqualTo(130)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(110)
        }
    }
}
