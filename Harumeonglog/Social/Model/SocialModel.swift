//
//  SocialModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 4/21/25.
//

import Foundation


// MARK: 게시글 조회 API
struct socialRespone : Decodable {
    let cursor : Int
    let hasNext : Bool
    let items : [socialItem]
}

struct socialItem : Decodable {
    let postId : Int
    let content : String
    let likeNum : Int
    let commentNum : Int
    let postCategory : String
    let memberInfoResponse : memberInfoResponse
    let imageKeyName: String
}

struct memberInfoResponse : Decodable {
    let memberId : Int
    let email : String
    let nickname : String
    let image : String
}

// MARK: 게시글 생성 API 
struct postSocialRequest : Encodable {
    let postCategory : String
    let content : String
    let postImageList : [String]
}
