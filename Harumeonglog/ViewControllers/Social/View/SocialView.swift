//
//  SocialView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/20/25.
//

import UIKit
import SnapKit
import Then

class ScialView: UIView {
    public lazy var searchBar = UITextField().then { textfield in
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.brown02.cgColor
        textfield.layer.cornerRadius = 20
        textfield.clipsToBounds = true
    }
    
    
}
