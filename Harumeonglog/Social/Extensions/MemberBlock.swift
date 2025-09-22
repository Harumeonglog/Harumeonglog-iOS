//
//  MemberBlock.swift
//  Harumeonglog
//
//  Created by 김민지 on 9/23/25.
//

import UIKit


extension UIViewController {
    
    func showBlockAlertView() {
        let alertView = AlertView(title: "사용자를 차단하시겠습니까 ?", confirmText: "차단")
        
        // 뒷배경 어둡게 처리
        if let window = UIApplication.shared.windows.first {
            let dimmedView = UIView(frame: window.bounds)
            dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            window.addSubview(dimmedView)
            window.addSubview(alertView)
            
            alertView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        alertView.confirmBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
        alertView.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
    }
    
    
    @objc private func confirmBtnTapped() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {  return  }

    }
    
    @objc private func cancelBtnTapped() {
        removeView(AlertView.self)
    }
    
    
    private func removeView<T: UIView>(_ viewType: T.Type) {
        if let window = UIApplication.shared.windows.first {
            window.subviews.forEach { subview in
                if subview is T || subview.backgroundColor == UIColor.black.withAlphaComponent(0.5) {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
}
