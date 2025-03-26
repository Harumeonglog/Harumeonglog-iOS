//
//  NotificationSettingViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/20/25.
//

import UIKit

class SetNotificationViewController: UIViewController {
    
    let setNotificationView = SetNotificationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = setNotificationView
    }
    
    override func viewDidLayoutSubviews() {
        setNotificationView.configure()
    }
    
}

import SwiftUI
#Preview {
    SetNotificationViewController()
}
