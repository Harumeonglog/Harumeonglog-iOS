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
    
    lazy var addScheduleButton : UIButton = {
        let button = UIButton()
        button.setTitle("일정 추가", for: .normal)
        button.backgroundColor = .black
        return button
    }()

    private func addComponents(){
        self.addSubview(alarmButton)
        self.addSubview(addScheduleButton)
        
        alarmButton.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(81)
            make.leading.equalToSuperview().offset(352)
            make.width.height.equalTo(30)
        }
        addScheduleButton.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(81)
            make.leading.equalToSuperview().offset(100)
            make.width.height.equalTo(50)
        }
    }
}
