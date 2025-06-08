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
