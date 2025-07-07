//
//  InvitationRequestsService.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import Alamofire

enum InvitationRequestsService {
    
    static func getInvitaionRequests(cursor: Int, token: String, completion: @escaping (Result<HaruResponse<InvitationResult>, AFError>) -> Void) {
        let endpoint = "/api/v1/pets/invitations?cursor=\(cursor)&size=10"
        APIClient.getRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
    
    static func postInvitationRequest(petId: Int, token: String, mode: RequestReply, completion: @escaping (Result<HaruResponse<String>, AFError>) -> Void) {
        let endpoint = "/api/v1/pets/\(petId)/invitations"
        let parameters: [String: String] = ["response": mode.rawValue]
        APIClient.postRequest(endpoint: endpoint, parameters: parameters, completion: completion)
    }
    
}

struct InvitationResult: Codable {
    let members: [InvitationRequest]
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

enum RequestReply: String {
    case accept = "ACCEPT"
    case reject = "REJECT"
}
