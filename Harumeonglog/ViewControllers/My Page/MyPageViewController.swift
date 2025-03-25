//
//  BaseViewControllers.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private let myPageView = MyPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPageView
    }

    override func viewDidLayoutSubviews() {
        myPageView.setConstraints()
    }
    
}

import SwiftUI
#Preview {
    MyPageViewController()
}
