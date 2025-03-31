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
    
    public lazy var navigationBar = CustomNavigationBar()

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
        addSubview(navigationBar)
        
        inviteTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130) // 적절한 위치 조정
            make.leading.trailing.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        inviteTableView.reloadData() // 데이터 로드
    }
}


