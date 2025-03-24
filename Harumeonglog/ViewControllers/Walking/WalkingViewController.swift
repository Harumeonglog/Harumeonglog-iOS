//
//  WalkingViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/22/25.
//

import UIKit


class WalkingViewController: UIViewController {
    
    private lazy var walkingView: WalkingView = {
        let view = WalkingView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = walkingView
        
        walkingView.endBtn.addTarget(self, action: #selector(endBtnDidTap), for: .touchUpInside)
    }
    
    @objc private func endBtnDidTap() {
        showAlert()
    }
    
    private func showAlert() {
        let alertView = AlertView(title: "산책을 끝내시겠습니까 ?", confirmText: "종료")
        
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
    }
}
