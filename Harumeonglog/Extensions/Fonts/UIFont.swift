//
//  K.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

enum FontName : String{
    case pretendard_light = "Pretendard-Light"
    case pretendard_extralight = "Pretendard-ExtraLight"
    case pretendard_regular = "Pretendard-Regular"
    case pretendard_medium = "Pretendard-Medium"
    case pretendard_bold = "Pretendard-Bold"
}

extension UIFont {
    @nonobjc class var header: UIFont {
        return UIFont(name: FontName.pretendard_light.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15)
    }
    @nonobjc class var title: UIFont {
        return UIFont(name: FontName.pretendard_light.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15)
    }
    @nonobjc class var body: UIFont {
        return UIFont(name: FontName.pretendard_light.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15)
    }
    @nonobjc class var headline: UIFont {
        return UIFont(name: FontName.pretendard_light.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15)
    }
    @nonobjc class var description: UIFont {
        return UIFont(name: FontName.pretendard_light.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15)
    }
    
    
}
