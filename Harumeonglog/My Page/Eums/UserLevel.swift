//
//  UserLevel.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/7/25.
//

import UIKit

enum UserLevelEnum {
    case guest, owner
    
    func levelImage() -> UIImage {
        switch self {
        case .guest:
            return .guestSelected
        case .owner:
            return .ownerSelected
        }
    }
}
