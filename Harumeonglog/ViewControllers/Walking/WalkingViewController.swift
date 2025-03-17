//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit
import NMapsMap

class WalkingViewController: UIViewController {
    
    private lazy var walkingView: WalkingView = {
        let view = WalkingView()
        view.moveToUserLocationButton.addTarget(self, action: #selector(moveToUserLocationButtonTapped), for: .touchUpInside)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.walkingView
    
    }
    
    @objc func moveToUserLocationButtonTapped() {
        
    }


}

