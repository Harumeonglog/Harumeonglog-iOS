//
//  MemberBlockModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 9/23/25.
//

import Foundation

struct MemberBlockRequest: Codable {
    var reportedId: Int
}

struct MemberBlockResponse: Codable {
    var reporterId: Int
    var reportedId: Int
    var isBlock: Bool
}
