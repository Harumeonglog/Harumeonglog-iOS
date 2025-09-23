//
//  MemberBlock.swift
//  Harumeonglog
//
//  Created by 김민지 on 9/23/25.
//

import UIKit


extension UIViewController {
    func showBlockAlertView(reportedId: Int) {
        let alertView = AlertView(title: "사용자를 차단하시겠습니까 ?", confirmText: "차단")
        
        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene }).first?.windows.first else { return }
        
        let dimmedView = UIView(frame: window.bounds)
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmedView.isUserInteractionEnabled = true
        window.addSubview(dimmedView)
        
        dimmedView.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 배경 눌렀을 때 닫히도록
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissAlert(_:)))
        dimmedView.addGestureRecognizer(dismissTap)
        
        alertView.onConfirm = { [weak self, weak dimmedView] in
            guard let self,
                  let token = KeychainService.get(key: K.Keys.accessToken) else { return }
            
            MemberBlockService().blockMember(reportedId: reportedId, token: token) { result in
                DispatchQueue.main.async {
                    dimmedView?.removeFromSuperview()
                    print("차단 요청 완료: \(reportedId)")
                }
            }
        }
        
        // cancel 콜백
        alertView.onCancel = { [weak dimmedView] in
            dimmedView?.removeFromSuperview()
        }
    }
    
    @objc private func dismissAlert(_ gesture: UITapGestureRecognizer) {
        gesture.view?.removeFromSuperview()
    }
}
