//
//  AlarmView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit
import SnapKit

class AlarmView: UIView {

    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bg
        
        addComponents()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var inviteButton: UIButton = {
        let button = UIButton()
        button.setTitle("초대요청 + ", for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.titleLabel?.font = K.Font.body
        button.setTitleColor(.brown00, for: .normal)
        button.tintColor = .brown00
        button.backgroundColor = .brown02
        button.layer.cornerRadius = 15

        // 🔹 버튼 내부 전체 여백 (텍스트 왼쪽에서 25pt 떨어지도록 설정)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 15)

        // 🔹 텍스트 위치 조정 (텍스트 끝에서 아이콘까지 220pt 떨어지도록 설정)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 220)

        // 🔹 아이콘 위치 조정 (텍스트 끝에서 220pt 오른쪽으로 이동)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 210, bottom: 0, right: -200)

        return button
    }()
    

    private func addComponents(){
        self.addSubview(inviteButton)
        
        inviteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(128)
            make.centerX.equalToSuperview()
            make.width.equalTo(358)
            make.height.equalTo(40)
        }
    }
}
