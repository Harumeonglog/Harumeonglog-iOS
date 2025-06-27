//
//  UserLevel.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/7/25.
//

import UIKit

enum UserLevelEnum: String, Codable {
    case GUEST, OWNER
    
    func levelImage() -> UIImage {
        switch self {
        case .GUEST:
            return .guestSelected
        case .OWNER:
            return .ownerSelected
        }
    }
}
