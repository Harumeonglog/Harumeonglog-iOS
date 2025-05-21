//
//  EventModalView.swift
//  Harumeonglog
//

import UIKit
import SnapKit

protocol EventModalViewDelegate: AnyObject {
    func didSelectCategory(_ category: String?) // 카테고리 선택 시 전달
}

class EventModalView: UIView {
    
    weak var delegate: EventModalViewDelegate?

    // 일정 데이터 (외부에서 설정 가능)**
    var Events: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70 // 셀 높이
        tableView.separatorStyle = .none //구분선 제거
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        tableView.backgroundColor = .clear
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}
