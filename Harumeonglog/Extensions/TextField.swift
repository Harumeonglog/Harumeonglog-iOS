//
//  TextField.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/18/25.
//

import UIKit

extension UITextField {
    
    static func commonTextField() -> UITextField {
        return UITextField().then {
            $0.borderStyle = .roundedRect
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.brown02.cgColor
            
            $0.backgroundColor = .white
            $0.textColor = .black
            
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
    }
    
    func setPlaceholder(text: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.gray03
            ]
        )
    }
    
}
