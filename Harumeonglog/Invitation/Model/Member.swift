//
//  InviteMember.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/22/25.
//

import Foundation

struct Member: Codable {
    let memberId: Int
    let email: String
    let name: String
    let image: String?
    var level: UserLevelEnum?
}

struct SearchMemberResult: Codable {
    let members: [Member]
    let cursor: Int?
    let hasNext: Bool?
}
