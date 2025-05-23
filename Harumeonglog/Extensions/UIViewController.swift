//
//  UIViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func makeAction(title: String, color: UIColor, handler: @escaping UIActionHandler) -> UIAction {
        let action = UIAction(title: title, handler: handler)
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: color,
                .font: UIFont.headline
            ]
        )
        action.setValue(attributedTitle, forKey: "attributedTitle")
        return action
    }
    
}
