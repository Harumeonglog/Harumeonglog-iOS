//
//  NotificationSettingViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/20/25.
//

import UIKit

class NotificationSettingViewController: UIViewController {
    
    let notificationSettingView = NotificationSettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = notificationSettingView
    }
    
    override func viewDidLayoutSubviews() {
        notificationSettingView.configure()
    }
    
}

import SwiftUI
#Preview {
    NotificationSettingViewController()
}
