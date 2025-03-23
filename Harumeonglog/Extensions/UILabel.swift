//
//  UILabel.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/22/25.
//

import UIKit

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat) {
        guard let text = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

        
        
