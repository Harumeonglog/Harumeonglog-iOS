//
//  InviteUserViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/6/25.
//

import UIKit

class InviteUserViewController: UIViewController {
    
    private let inviteUserView = InviteUserView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = inviteUserView
    }
}

import SwiftUI
#Preview {
    InviteUserViewController()
}
