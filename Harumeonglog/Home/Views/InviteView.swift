//
//  InviteView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit

protocol InviteViewDelegate: AnyObject {
    func acceptButtonTapped(at indexPath: IndexPath)
    func declineButtonTapped(at indexPath: IndexPath)
}

class InviteView: UIView {
    
    weak var delegate: InviteViewDelegate?
    
    //더미데이터
    var inviteData: [(profileImage: String, nickname: String)] = [
            ("dog1", "its_mmee"),
            ("dog1", "its_mmee"),
            ("dog1", "its_mmee")
        ]

    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bg
        
        addComponents()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 초대 요청을 표시할 테이블 뷰
    lazy var inviteTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(InviteCell.self, forCellReuseIdentifier: "InviteCell") // 커스텀 셀 등록
        tableView.backgroundColor = .clear
        return tableView
    }()

    private func addComponents() {
        self.addSubview(inviteTableView)
        
        inviteTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130) // 적절한 위치 조정
            make.leading.trailing.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        inviteTableView.reloadData() // 데이터 로드
    }
}

// UITableView Delegate & DataSource 구현
extension InviteView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as! InviteCell
        let data = inviteData[indexPath.row]
        cell.configure(profileImage: data.profileImage, nickname: data.nickname)
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 // 셀 높이 조정
    }
    // UITableViewDelegate - 셀 간 간격 추가
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 // 셀과 셀 사이의 간격 추가
    }
    @objc private func acceptButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? InviteCell,
              let indexPath = inviteTableView.indexPath(for: cell) else { return }
        delegate?.acceptButtonTapped(at: indexPath)
    }

    @objc private func declineButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? InviteCell,
              let indexPath = inviteTableView.indexPath(for: cell) else { return }
        delegate?.declineButtonTapped(at: indexPath) 
    }
}
