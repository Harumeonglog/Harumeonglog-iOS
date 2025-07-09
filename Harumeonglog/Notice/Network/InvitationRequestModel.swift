//
//  InvitationRequestModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import Foundation

struct InvitationResult: Codable {
    let invitations: [InvitationRequest]
    let size: Int
    let hasNext: Bool?
    let nextCursor: Int?
}

struct InvitationRequest: Codable {
    let invitationId: Int
    let image: String
    let petId: Int
    let petName: String
    let role: String
    let senderId: Int
    let senderName: String?
    let createdAt: String?
}

