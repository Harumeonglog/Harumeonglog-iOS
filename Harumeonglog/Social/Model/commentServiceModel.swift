//
//  commentServiceModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 5/12/25.
//

import Foundation


//MARK: 댓글 조회 API
struct commentRequest: Codable {
    let postId : Int
    let cursor : Int
    let size : Int
}

struct commentResponse: Codable {
    let items : [commentItem]
    let hasNext : Bool
    let cursor : Int
}

struct commentItem: Codable {
    let commentId : Int
    let content : String
    let memberInfoResponse: MemberInfoResponse
    let commentcommentResponseList : [commentcommentResponse]   // 대댓글 리스트
}

struct commentcommentResponse : Codable {
    let commentId : Int
    let content : String
    let memberInfoResponse: MemberInfoResponse
}


// MARK: 댓글 생성 API
struct addCommentRequest: Codable {
    let content : String
    let parentId : String
    //  parentId가 null이면 댓글 Long 값이 들어가면 대댓글(해당 parentId의 댓글에 종속되는)
}

struct addCommentResponse: Decodable {
    let commentId : Int
    let createdAt : String
    let updateAt : String
}

