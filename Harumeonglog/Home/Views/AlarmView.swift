//
//  AlarmView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit
import SnapKit

class AlarmView: UIView {
    
    // 알람 데이터 배열 (샘플 데이터)
        var alarmData: [(icon: String, title: String, time: String)] = [
            ("sun.max", "오늘의 멍이를 기록하세요!", ""),
            ("message", "카이 님이 회원님의 게시글을 좋아합니다.", "1시간"),
            ("message", "카이 님이 회원님의 게시글을 좋아합니다.", "1시간"),
            ("message", "카이 님이 회원님의 게시글을 좋아합니다.", "1시간"),
            ("pencil", "일정 알림", "")
        ]

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
    
    lazy var alarmTableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .bg
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none // 구분선 제거
        tableView.showsVerticalScrollIndicator = false
        tableView.register(AlarmCell.self, forCellReuseIdentifier: "AlarmCell") 
        return tableView
    }()
    

    private func addComponents(){
        
        self.addSubview(inviteButton)
        self.addSubview(alarmTableView)
        
        inviteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(128)
            make.centerX.equalToSuperview()
            make.width.equalTo(358)
            make.height.equalTo(40)
        }
        alarmTableView.snp.makeConstraints { make in
            make.top.equalTo(inviteButton.snp.bottom).offset(25)
            make.width.equalTo(350)
            make.centerX.equalToSuperview()
            make.height.equalTo(650)
        }
    }
}

// UITableView Delegate & DataSource 구현
extension AlarmView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        let data = alarmData[indexPath.row]
        cell.configure(icon: data.icon, title: data.title, time: data.time)
        cell.backgroundColor = .bg
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // 셀 높이 조정
    }
}
