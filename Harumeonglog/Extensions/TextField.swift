//
//  TextField.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/18/25.
//

import UIKit

extension UITextField {
    
    func setPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: color
            ]
        )
    }
    
}
