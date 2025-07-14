//
//  UIViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

extension UIViewController : UITextFieldDelegate, UITextViewDelegate {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // 모든 서브뷰에 대해 delegate 자동 설정
        setDelegateForTextInputs(in: view)
    }
    
    private func setDelegateForTextInputs(in view: UIView) {
        for subview in view.subviews {
            if let textField = subview as? UITextField {
                textField.delegate = self
                textField.returnKeyType = .done
            } else if let textView = subview as? UITextView {
                textView.delegate = self
            } else {
                // 재귀적으로 하위 뷰 탐색
                setDelegateForTextInputs(in: subview)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // UITextField 엔터 처리
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // UITextView 엔터 처리
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension UIViewController {
    
    // MARK: UIAction string 설정
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
    
    // MARK: 이미지 URL -> UIImage로 변환
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("잘못된 URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("이미지 다운로드 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("데이터 변환 실패")
                completion(nil)
                return
            }

            completion(image)
        }.resume()
    }
}
