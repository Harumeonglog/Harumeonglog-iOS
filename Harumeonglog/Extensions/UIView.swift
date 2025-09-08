//
//  UIView+FirstResponder.swift
//  Harumeonglog
//
//  Created by Assistant on 6/21/25.
//

import UIKit

extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder { return self }
        for subview in subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}

//
//  TextField.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/18/25.
//

import UIKit
import Foundation

extension UITextField {
    
    static func commonTextField() -> UITextField {
        return UITextField().then {
            $0.borderStyle = .roundedRect
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.brown02.cgColor
            
            $0.backgroundColor = .white
            $0.textColor = .gray00
            
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

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat, alignment: NSTextAlignment = .left) {
        guard let text = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment  
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }

}
