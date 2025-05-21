//
//  EventModalView+UITable.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
// 일정 목록 표시 및 클릭 처리

import UIKit

extension EventModalView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate & DataSource
    
    // UITableView DataSource & Delegate (일정 리스트)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as! EventCell
        cell.configure(Event: Events[indexPath.row], isChecked: false) // 기본 체크 해제 상태
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

