//
//  SocialPostService.swift
//  Harumeonglog
//
//  Created by 김민지 on 4/30/25.
//

import Foundation
import Alamofire

// Post 관련 API
class SocialPostService {
    
    func getPostListFromServer(token: String, completion: @escaping (Result<HaruResponse<postListResponse>, AFError>) -> Void) {
        
        let endpoint = "/api/v1/posts"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    
    func sendPostToServer(token: String, completion: @escaping (Result<HaruResponse<addPostResponse>, AFError>) -> Void) {
        
        let endpoint = "/api/v1/posts"
        APIClient.postRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
}
