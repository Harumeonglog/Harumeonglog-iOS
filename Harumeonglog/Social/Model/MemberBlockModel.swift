//
//  MemberBlockModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 9/23/25.
//

import Foundation

struct MemberBlockRequest: Codable {
    let reportedId: Int
}

struct MemberBlockResponse: Codable {
    let reporterId: Int
    let reportedId: Int
    let isBlock: Bool
}
