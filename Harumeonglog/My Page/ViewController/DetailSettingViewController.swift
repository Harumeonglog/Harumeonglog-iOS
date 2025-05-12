//
//  NotificationSettingViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/20/25.
//

import UIKit

class DetailSettingViewController: UIViewController {
    
    let detailSettingView = DetailSettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailSettingView
        detailSettingView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        detailSettingView.configure()
    }
    
    @objc
    private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

import SwiftUI
#Preview {
    DetailSettingViewController()
}
