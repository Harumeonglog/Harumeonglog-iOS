//
//  InviteViewController.swift
//  Harumeonglog
//
//  Created by 임지빈 on 3/13/25.
//

import UIKit

class InviteViewController: UIViewController {

    private lazy var inviteView:  InviteView = {
        let view = InviteView()
        view.delegate = self
        return view
        }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = inviteView
        setCustomNavigationBarConstraints()
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = inviteView.navigationBar
        navi.configureTitle(title: "초대 요청")
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
}

// InviteViewDelegate 구현
extension InviteViewController: InviteViewDelegate {
    func acceptButtonTapped(at indexPath: IndexPath) {
        inviteView.inviteData.remove(at: indexPath.row)
        inviteView.inviteTableView.deleteRows(at: [indexPath], with: .fade)
    }

    func declineButtonTapped(at indexPath: IndexPath) {
        inviteView.inviteData.remove(at: indexPath.row)
        inviteView.inviteTableView.deleteRows(at: [indexPath], with: .fade)
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
