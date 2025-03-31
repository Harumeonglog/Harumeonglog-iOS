//
//  NotiModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import Foundation

struct NotiModel {
    let type: NotiTypeEnum
    let isRead: Bool
    let userNickname: String?
    let date: String
}

class NotiModelList {
    static let data: [NotiModel] = [
        NotiModel(type: .todo, isRead: false, userNickname: nil, date: "1시간"),
        NotiModel(type: .comment, isRead: true, userNickname: "김동현", date: "1시간"),
        NotiModel(type: .morning, isRead: false, userNickname: nil, date: "1시간"),
        NotiModel(type: .liked, isRead: true, userNickname: "이수진", date: "1시간"),
        NotiModel(type: .todo, isRead: true, userNickname: nil, date: "1시간"),
        NotiModel(type: .comment, isRead: false, userNickname: "박지훈", date: "1시간"),
        NotiModel(type: .morning, isRead: true, userNickname: nil, date: "1시간"),
        NotiModel(type: .liked, isRead: false, userNickname: "최민수", date: "1시간"),
        NotiModel(type: .todo, isRead: false, userNickname: nil, date: "1시간"),
        NotiModel(type: .comment, isRead: true, userNickname: "김동현", date: "1시간"),
        NotiModel(type: .morning, isRead: false, userNickname: nil, date: "1시간"),
        NotiModel(type: .liked, isRead: true, userNickname: "이수진", date: "1시간"),
        NotiModel(type: .todo, isRead: true, userNickname: nil, date: "1시간"),
        NotiModel(type: .comment, isRead: false, userNickname: "박지훈", date: "1시간"),
        NotiModel(type: .morning, isRead: true, userNickname: nil, date: "1시간"),
        NotiModel(type: .liked, isRead: false, userNickname: "최민수", date: "1시간"),
        NotiModel(type: .todo, isRead: false, userNickname: nil, date: "1시간"),
        NotiModel(type: .comment, isRead: true, userNickname: "김동현", date: "1시간"),
        NotiModel(type: .morning, isRead: false, userNickname: nil, date: "1시간"),
        NotiModel(type: .liked, isRead: true, userNickname: "이수진", date: "1시간"),
        NotiModel(type: .todo, isRead: true, userNickname: nil, date: "1시간"),
        NotiModel(type: .comment, isRead: false, userNickname: "박지훈", date: "1시간"),
        NotiModel(type: .morning, isRead: true, userNickname: nil, date: "1시간"),
        NotiModel(type: .liked, isRead: false, userNickname: "최민수", date: "1시간"),

    ]
}
