//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit
import NMapsMap

class WalkingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let naverMapView = NMFNaverMapView(frame: view.frame)
        view.addSubview(naverMapView)
        
    }


}

