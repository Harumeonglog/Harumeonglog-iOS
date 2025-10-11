//
//  MemberBlockService.swift
//  Harumeonglog
//
//  Created by 김민지 on 9/23/25.
//

import Foundation
import Alamofire

class MemberBlockService {
    
    func blockMember(
        reportedId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<MemberBlockResponse>, AFError>) -> Void) {
                         
        let endpoint = "/api/v1/member-block"
        let requestBody = MemberBlockRequest(reportedId: reportedId)
                     
        APIClient.postRequest(endpoint: endpoint, parameters: requestBody, token: token, completion: completion)
    }
}
