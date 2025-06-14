//
//  WalkMemberModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/14/25.
//

import Foundation

struct WalkPetResposne: Decodable {
    let pets: [WalkPets]
    let size: Int
}

struct WalkPets: Decodable {
    let petId: Int
    let name: String
    let image : String
}

struct WalkMemberResponse : Decodable {
    let members: [WalkMembers]
    let size: Int
}

struct WalkMembers: Decodable {
    let memberId: Int
    let nickname: String
    let image : String
}
