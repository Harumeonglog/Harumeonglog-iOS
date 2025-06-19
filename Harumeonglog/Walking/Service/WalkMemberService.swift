//
//  WalkMemberService.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/15/25.
//

import Foundation
import Alamofire

class WalkMemberService {
    
    func fetchWalkAvailablePet(
        token: String,
        completion: @escaping (Result<HaruResponse<WalkPetResposne>, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/walks/pets"
        
        APIClient.getRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
    
    func fetchWalkAvailableMember(
        petId: [Int],
        token: String,
        completion: @escaping (Result<HaruResponse<WalkMemberResponse>, AFError>) -> Void
    ) {
        
        let endpoint = "/api/v1/walks/members"
        let requestBody = WalkMemberRequest(petId: petId)
        
        APIClient.postRequest(endpoint: endpoint, parameters: requestBody, token: token, completion: completion)
    }
    
}
