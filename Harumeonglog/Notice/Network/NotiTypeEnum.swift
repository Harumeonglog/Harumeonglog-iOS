//
//  File.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import UIKit

enum NotiTypeEnum: String, Codable {
    case EVENT, COMMENT, NOTICE, ARTICLE, INVITATION
    
    func typeImage() -> UIImage {
        switch self {
        case .INVITATION:
            return .friends
        case .EVENT:
            return .edit
        case .COMMENT, .ARTICLE:
            return .comment
        case .NOTICE:
            return .sunshine
        }
    }
    
}
