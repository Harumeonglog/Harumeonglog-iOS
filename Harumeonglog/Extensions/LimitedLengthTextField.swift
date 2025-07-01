//
//  LimitedLengthTextField.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/30/25.
//

import UIKit

class LimitedLengthTextField: UITextField, UITextFieldDelegate {
    
    var maxLength: Int = 10 {
        didSet {
            self.delegate = self
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else {
            return false
        }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= maxLength
    }
}
