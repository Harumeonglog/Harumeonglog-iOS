//
//  File.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import UIKit

enum NotiTypeEnum: Codable {
    case todo, comment, morning, liked
    
    func typeImage() -> UIImage {
        switch self {
        case .todo:
            return .edit
        case .comment, .liked:
            return .comment
        case .morning:
            return .sunshine
        }
    }
    
    func typeMessage() -> String {
        switch self {
        case .todo:
            return "일정 알림"
        case .comment:
            return "님이 회원님의 게시글에 댓글을 작성했습니다."
        case .liked:
            return "님이 회원님의 게시글을 좋아합니다."
        case .morning:
            return "오늘의 멍이를 기록하세요."
        }
    }
}
