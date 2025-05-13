//
//  postServiceModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 4/21/25.
//

import Foundation


// MARK: 게시글 조회 API
struct postRequest : Encodable {
    let search : String?
    let postRequestCategory: String
    let cursor : Int
    let size : Int
}

struct postListResponse : Codable {
    let cursor : Int
    let hasNext : Bool
    let items : [postItem]
}

struct postItem : Codable {
    let postId : Int
    let content : String
    let likeNum : Int
    let commentNum : Int
    let postCategory : String
    let memberInfoResponse : memberInfoResponse
    let imageKeyName: String
}

struct memberInfoResponse : Codable {
    let memberId : Int
    let email : String
    let nickname : String
    let image : String
}

// MARK: 게시글 상세 조회 API
struct postDetailResponse : Codable {
    let postId : Int
    let content : String
    let title : String
    let likeNum : Int
    let commentNum : Int
    let postCategory : String
    let memberInfoResponse : memberInfoResponse
    let postImageList : [String]
}

// MARK: 게시글 생성 API 
struct addPostRequest : Encodable {
    let postCategory : String
    let title: String
    let content : String
    let postImageList : [URL]
}

struct addPostResponse : Codable {
    let postId : Int
    let createAt: String
    let updateAt: String
}
