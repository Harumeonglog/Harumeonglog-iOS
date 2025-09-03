//
//  SocialCommentService.swift
//  Harumeonglog
//
//  Created by 김민지 on 4/30/25.
//

import Foundation
import Alamofire

// Comment 관련 API
class SocialCommentService {
    
    func getCommentListFromServer(
        postId: Int,
        cursor: Int,
        size: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<CommentResponse>, AFError>) -> Void) {

        let endpoint = "/api/v1/posts/\(postId)/comments"
        var parameters: [String: Any] = [
            "cursor": cursor,
            "size": size
        ]
        
        print("댓글 조회 body: \(parameters)")
        APIClient.getRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
    // 댓글
    func postCommentToServer(
        postId: Int,
        parentId: Int?,
        content: String,
        token: String,
        completion: @escaping (Result<HaruResponse<AddCommentResponse>, AFError>) -> Void) {
            
        let endpoint = "/api/v1/posts/\(postId)/comments"
        let requestBody = AddCommentRequest(content: content, parentId: parentId)
        
        APIClient.postRequest(endpoint: endpoint, parameters: requestBody, token: token, completion: completion)
    }
    
    // 대댓글
    func postReplyCommentToServer(
        postId: Int,
        content: String,
        parentId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<AddCommentResponse>, AFError>) -> Void) {
            
        let endpoint = "/api/v1/posts/\(postId)/comments"
        let requestBody = AddCommentRequest(content: content, parentId: parentId)
        
        APIClient.postRequest(endpoint: endpoint, parameters: requestBody, token: token, completion: completion)
    }
    
    func reportCommentToServer(
        commentId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<HaruEmptyResult>, AFError>) -> Void) {
        
        let endpoint = "/api/v1/comments/\(commentId)/reports"
            
        APIClient.postRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
    
    func blockCommentToServer(
        commentId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<HaruEmptyResult>, AFError>) -> Void) {
            
        let endpoint = "/api/v1/comments/\(commentId)/blocks"
            
        APIClient.postRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
}
