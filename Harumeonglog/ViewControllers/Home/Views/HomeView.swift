//
//  HomeView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit
import SnapKit

class HomeView: UIView {

    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bg
        
        addComponents()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "alarm_button"), for: .normal)
        return button
    }()

    private func addComponents(){
        self.addSubview(alarmButton)
        
        alarmButton.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(100)
            make.width.height.equalTo(30)
        }
    }
}
