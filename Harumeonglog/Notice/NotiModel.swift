//
//  NotiModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import Foundation

struct NoticesResult: Codable {
    let items: [NoticeModel]?
    let hasNext: Bool
    let cursor: Int?
}

struct NoticeModel: Codable {
    let noticeId: Int
    let title: String
    let content: String
    let noticeType: NotiTypeEnum
    let targetId: Int
}
