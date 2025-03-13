//
//  K.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

struct K {
    
    struct FontName {
        static let pretendard_bold = "Pretendard-Bold"
        static let pretendard_medium = "Pretendard-Medium"
        static let pretendard_regular = "Pretendard-Regular"
    }
    
    struct Font {
        static let header = UIFont(name: K.FontName.pretendard_bold, size: 28)
        static let title = UIFont(name: K.FontName.pretendard_bold, size: 24)
        static let headline = UIFont(name: K.FontName.pretendard_medium, size: 20)
        static let body = UIFont(name: K.FontName.pretendard_regular, size: 14)
        static let description = UIFont(name: K.FontName.pretendard_regular, size: 12)
    }
    
}
