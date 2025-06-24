//
//  MapExtension.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/24/25.
//

import UIKit


// 위치 접근 권한 허용안한 경우 설정에 들어가도록 유도
extension UIViewController {
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "위치 권한 필요",
                                      message: "현재 위치를 사용하려면 설정에서\n 위치 접근을 허용해 주세요.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
