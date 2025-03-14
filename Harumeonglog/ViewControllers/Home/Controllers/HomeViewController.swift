//
//  HomeViewController.swift
//  Harumeonglog
//
//  Created by 임지빈 on 3/13/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var homeView:  HomeView = {
            let view = HomeView()
            return view
        }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        homeView.alarmButton.addTarget(self, action: #selector(alarmButtonTap), for: .touchUpInside)
    }
    
    @objc func alarmButtonTap(){
        let alarmVC = AlarmViewController()
        self.navigationController?.pushViewController(alarmVC, animated: true )
    }
}
