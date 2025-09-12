//
//  NotiModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import Foundation

struct NoticesResult: Codable {
    let items: [NoticeModel]?
    let hasNext: Bool?
    let cursor: Int?
}

struct NoticeModel: Codable {
    let noticeId: Int?
    let title: String?
    let content: String?
    let noticeType: NotiTypeEnum?
    let targetId: Int?
    let senderName: String?
    let createdAt: String?
}
//
//"noticeId": 45,
//        "title": "[초대 알림]",
//        "content": "도비에 초대되었습니다.",
//        "noticeType": "INVITATION",
//        "targetId": null,
//        "senderName": "rofxnaos",
//        "createdAt": "2025-09-10T17:06:06.106028"
