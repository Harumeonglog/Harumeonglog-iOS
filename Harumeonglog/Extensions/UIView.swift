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
    func setLineSpacing(lineSpacing: CGFloat) {
        guard let text = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }

}

extension UIView {
    func timeAgoString(from createdAtString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 9 * 3600) // KST 기준으로 파싱

        guard let createdAt = formatter.date(from: createdAtString) else {
            return "알 수 없음"
        }

        let now = Date()
        let interval = now.timeIntervalSince(createdAt)

        if interval < 60 {
            return "\(Int(interval))초 전"
        } else if interval < 3600 {
            return "\(Int(interval / 60))분 전"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))시간 전"
        } else {
            return "\(Int(interval / 86400))일 전"
        }
    }
}
