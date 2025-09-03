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
        APIClient.postRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
}
