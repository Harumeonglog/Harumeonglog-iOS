//
//  InviteMemberService.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/23/25.
//

import Alamofire

enum InviteMemberService {
    
    static func searchUsers(keyword: String, cursor: Int, token: String, completion: @escaping (Result<HaruResponse<SearchMemberResult>, AFError>) -> Void) {
        let url = K.haruURL + "/api/v1/members?emil=\(keyword)&cursor=\(cursor)&siz=10"
        APIClient.getRequestWithoutParameters(endpoint: url, token: token, completion: completion)
    }
    
    static func inviteUser(petID: Int, users: [Member], token: String, completion: @escaping (Result<HaruResponse<String>, AFError>) -> Void) {
        let url = K.haruURL + "/api/v1/pets/\(petID)/members"
        
        struct InviteRequest: Encodable {
            let requests: [InviteMember]
        }
        
        struct InviteMember: Encodable {
            let memberId: Int
            let role: String
        }
        
        let inviteMembers = users.map { InviteMember(memberId: $0.memberId, role: $0.level!.rawValue) }
        let requestBody = InviteRequest(requests: inviteMembers)
        
        APIClient.postRequest(endpoint: url,
                              parameters: requestBody,
                              token: token,
                              completion: completion)
    }
    
}
