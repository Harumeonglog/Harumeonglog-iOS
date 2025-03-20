//
//  EditProfileViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/19/25.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    private let editProfileView = EditProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editProfileView
    }

    override func viewDidLayoutSubviews() {
        editProfileView.setConstraints()
    }
    
}

import SwiftUI
#Preview {
    EditProfileViewController()
}
