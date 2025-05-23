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
    
    func getPostListFromServer(
        search: String?,
        postRequestCategory: String,
        cursor: Int,
        size: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<PostListResponse>, AFError>) -> Void) {
        
        let endpoint = "/api/v1/posts"
        var parameters: [String: Any] = [
            "postRequestCategory": postRequestCategory,
            "cursor": cursor,
            "size": size
        ]
            
        if let search = search {
            parameters["search"] = search
        }
        
        print("게시글 조회 body: \(parameters)")
        APIClient.getRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
    
    func sendPostToServer(
        postCategory: String,
        title: String,
        content: String,
        postImageList: [String],
        token: String,
        completion: @escaping (Result<HaruResponse<AddPostResponse>, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/posts"
        let body = AddPostRequest(postCategory: postCategory, title: title, content: content, postImageList: postImageList)
        
        print("게시글 생성 body: \(body)")
        APIClient.postRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }
    
    func getPostDetailsFromServer(
        postId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<PostDetailResponse>, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/posts/\(postId)"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    func likePostToServer(
        postId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<HaruEmptyResult>, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/posts/\(postId)/likes"
        
        APIClient.postRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
    
    func reportPostToServer(
        postId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<HaruEmptyResult>, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/posts/\(postId)/reports"
        APIClient.postRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
    
    func deletePostToServer(
        postId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<HaruEmptyResult>, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/posts/\(postId)"
        APIClient.deleteRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    func modifyPostToServer(
        postId: Int,
        postCategory: String,
        title: String,
        content: String,
        postImageList: [String],
        token: String,
        completion: @escaping (Result<HaruResponse<ModifyPostResponse>, AFError>) -> Void
    ){
        let endpoint = "/api/v1/posts/\(postId)"
        let body = ModifyPostRequest(postCategory: postCategory, title: title, content: content, postImageList: postImageList)
        
        APIClient.patchRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }
    
}
