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
        setButtonAction()
        swipeRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        detailSettingView.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSetting()
        
    }
    
    private func setButtonAction() {
        detailSettingView.commentNotification.switchView.addTarget(self, action: #selector(patchSetting), for: .touchUpInside)
        detailSettingView.morningNotification.switchView.addTarget(self, action: #selector(patchSetting), for: .touchUpInside)
        detailSettingView.todoNotification.switchView.addTarget(self, action: #selector(patchSetting), for: .touchUpInside)
        detailSettingView.likeNotification.switchView.addTarget(self, action: #selector(patchSetting), for: .touchUpInside)
    }
    
    private func getSetting() {
        MemberAPIService.getSetting { code, result in
            switch code {
            case .COMMON200:
                if let result = result {
                    self.detailSettingView.commentNotification.switchView.isOn = result.commentAlarm
                    self.detailSettingView.morningNotification.switchView.isOn = result.morningAlarm
                    self.detailSettingView.todoNotification.switchView.isOn = result.eventAlarm
                    self.detailSettingView.likeNotification.switchView.isOn = result.articleLikeAlarm
                }
            case .AUTH400, .AUTH401, .ERROR500:
                break
            }
        }
    }
    
    @objc
    private func patchSetting() {
        let switches = [
            self.detailSettingView.morningNotification.switchView,
            self.detailSettingView.todoNotification.switchView,
            self.detailSettingView.likeNotification.switchView,
            self.detailSettingView.commentNotification.switchView,
        ]
        
        MemberAPIService.patchSetting(
            param: SettingParameter(morningAlarm: switches[0].isOn, eventAlarm: switches[1].isOn, articleLikeAlarm: switches[2].isOn, commentAlarm: switches[3].isOn)) { code in
                switch code {
                case .COMMON200:
                    print("Patch Setting Succeed")
                case .AUTH400, .AUTH401, .ERROR500:
                    print("Patch Setting Failed")
                }
            }
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
