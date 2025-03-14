//
//  AddScheduleViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit

class AddScheduleViewController: UIViewController {

    private lazy var addScheduleView:  AddScheduleView = {
            let view = AddScheduleView()
            return view
        }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addScheduleView
    }
    
}
