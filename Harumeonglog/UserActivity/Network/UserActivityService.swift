//
//  UserActivityService.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import Alamofire

enum UserActivityService {
    
    static func getMyPosts(cursor: Int, completion: @escaping (Result<HaruResponse<PostListResponse>, AFError>) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        let endpoint = "/api/v1/posts/me?cursor=\(cursor)&size=10"
        APIClient.getRequest(endpoint: endpoint, token: accessToken, completion: completion)
    }
    
    static func getLikedPosts(cursor: Int, completion: @escaping (Result<HaruResponse<PostListResponse>, AFError>) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        let endpoint = "/api/v1/posts/me/likes?cursor=\(cursor)&size=10"
        APIClient.getRequest(endpoint: endpoint, token: accessToken, completion: completion)
    }
    
    static func getMyComments(cursor: Int, completion: @escaping (Result<HaruResponse<MyCommentsResult> , AFError>) -> Void ) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        let endpoint = "/api/v1/comments/me?cursor=\(cursor)&size=10"
        APIClient.getRequest(endpoint: endpoint, token: accessToken, completion: completion)
    }
    
}

struct MyCommentsResult: Codable {
    let items: [MyCommentItem]
    let hasNext: Bool
    let cursor: Int?
}

struct MyCommentItem: Codable {
    let commentId: Int
    let content: String
    let createdAt: String
}

