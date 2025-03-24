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
    }
    
}

// ✅ InviteViewDelegate 구현
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
