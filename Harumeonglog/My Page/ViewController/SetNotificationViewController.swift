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
        setNotificationView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        setNotificationView.configure()
    }
    
    @objc
    private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

import SwiftUI
#Preview {
    SetNotificationViewController()
}
