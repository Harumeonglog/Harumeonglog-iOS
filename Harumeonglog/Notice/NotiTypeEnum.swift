//
//  File.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import UIKit

enum NotiTypeEnum: Codable {
    case EVENT, COMMENT, NOTICE, ARTICLE
    
    func typeImage() -> UIImage {
        switch self {
        case .EVENT:
            return .edit
        case .COMMENT, .ARTICLE:
            return .comment
        case .NOTICE:
            return .sunshine
        }
    }
    
}
