//
//  UIIMage.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
