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
            return view
        }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = inviteView
    }
    
}
