//
//  AlarmViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit

class AlarmViewController: UIViewController {

    private lazy var alarmView:  AlarmView = {
            let view = AlarmView()
            return view
        }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = alarmView
        alarmView.inviteButton.addTarget(self, action: #selector(inviteButtonTap), for: .touchUpInside)
    }
    
    @objc func inviteButtonTap(){
        let inviteVC = InviteViewController()
        self.navigationController?.pushViewController(inviteVC, animated: true )
    }
}
