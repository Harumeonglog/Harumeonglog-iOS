//
//  InviteMemberService.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/23/25.
//

import Alamofire

enum InviteMemberService {
    
    static func searchUsers(keyword: String, cursor: Int, token: String, completion: @escaping (Result<HaruResponse<SearchMemberResult>, AFError>) -> Void) {
        let endpoint = "/api/v1/pets/members?email=\(keyword)&cursor=\(cursor)&size=10"
        APIClient.getRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
    
    static func inviteUser(petID: Int, users: [Member], completion: @escaping (Result<HaruResponse<String>, AFError>) -> Void) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { print("NO Access Token"); return }
        let endpoint = "/api/v1/pets/\(petID)/members"
        
        struct InviteRequest: Encodable {
            let requests: [InviteMember]
        }
        
        struct InviteMember: Encodable {
            let memberId: Int
            let role: String
        }
        
        let inviteMembers = users.map { InviteMember(memberId: $0.memberId, role: $0.level!.rawValue) }
        let requestBody = InviteRequest(requests: inviteMembers)
        
        APIClient.postRequest(endpoint: endpoint, parameters: requestBody, token: token, completion: completion)
    }
    
}
