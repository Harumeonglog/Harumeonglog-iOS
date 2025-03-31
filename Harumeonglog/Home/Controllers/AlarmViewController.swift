//
//  AlarmViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit

class AlarmViewController: UIViewController {

    private lazy var alarmView: AlarmView = {
        let view = AlarmView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = alarmView
        alarmView.alarmTableView.delegate = self
        alarmView.alarmTableView.dataSource = self
        setCustomNavigationBarConstraints()
        alarmView.inviteButton.addTarget(self, action: #selector(inviteButtonTap), for: .touchUpInside)
    }

    @objc func inviteButtonTap() {
        let inviteVC = InviteViewController()
        self.navigationController?.pushViewController(inviteVC, animated: true)
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = alarmView.navigationBar
        navi.configureTitle(title: "알림")
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
}
// UITableView Delegate & DataSource 구현
extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmView.alarmData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        let data = alarmView.alarmData[indexPath.row]
        cell.configure(icon: data.icon, title: data.title, time: data.time)
        cell.backgroundColor = .bg
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // 셀 높이 조정
    }
}
