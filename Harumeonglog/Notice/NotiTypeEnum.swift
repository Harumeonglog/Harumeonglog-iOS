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
    
//    func typeMessage() -> String {
//        switch self {
//        case .EVENT:
//            return "일정 알림"
//        case .COMMENT:
//            return "님이 회원님의 게시글에 댓글을 작성했습니다."
//        case .ARTICLE:
//            return "님이 회원님의 게시글을 좋아합니다."
//        case .NOTICE:
//            return "오늘의 멍이를 기록하세요."
//        }
//    }
}
