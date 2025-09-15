//
//  NotiModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import Foundation

struct NoticesResult: Codable {
    var items: [NoticeModel]?
    let hasNext: Bool?
    let cursor: Int?
}

struct NoticeModel: Codable {
    var isRead: Bool = false
    let noticeId: Int?
    let title: String?
    let content: String?
    let noticeType: NotiTypeEnum?
    let targetId: Int?
    let senderName: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case noticeId, title, content, noticeType, targetId, senderName, createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        noticeId = try container.decodeIfPresent(Int.self, forKey: .noticeId)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        noticeType = try container.decodeIfPresent(NotiTypeEnum.self, forKey: .noticeType)
        targetId = try container.decodeIfPresent(Int.self, forKey: .targetId)
        senderName = try container.decodeIfPresent(String.self, forKey: .senderName)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        
        // JSON에 없는 값은 기본값으로 세팅
        isRead = false
    }
    
    mutating func read() {
        isRead = true
    }
}
//
//"noticeId": 45,
//        "title": "[초대 알림]",
//        "content": "도비에 초대되었습니다.",
//        "noticeType": "INVITATION",
//        "targetId": null,
//        "senderName": "rofxnaos",
//        "createdAt": "2025-09-10T17:06:06.106028"
