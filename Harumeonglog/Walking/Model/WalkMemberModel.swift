//
//  WalkMemberModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/14/25.
//

import Foundation

struct WalkPetResposne: Codable {
    let pets: [WalkPets]
    let size: Int
    
    struct WalkPets: Codable {
        let petId: Int
        let name: String
        let image : String
    }

}

struct WalkMemberRequest: Codable {
    let petId: [Int]
}

struct WalkMemberResponse : Codable {
    let members: [WalkMembers]
    let size: Int
    
    struct WalkMembers: Codable {
        let memberId: Int
        let nickname: String
        let image : String
    }
}
