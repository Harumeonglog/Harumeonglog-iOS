//
//  commentServiceModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 5/12/25.
//

import Foundation


//MARK: 댓글 조회 API
struct commentRequest: Encodable {
    let postId : Int
    let cursor : Int
    let size : Int
}

struct commentResponse: Decodable {
    let items : [commentItem]
    let hasNext : Bool
    let cursor : Int
}

struct commentItem: Decodable {
    let commentId : Int
    let content : String
    let memberInfoResponse: memberInfoResponse
    let commentcommentResponseList : [commentcommentResponse]   // 대댓글 리스트
}

struct commentcommentResponse : Decodable {
    let commentId : Int
    let content : String
    let memberInfoResponse: memberInfoResponse
}


// MARK: 댓글 생성 API
struct addCommentRequest: Encodable {
    let content : String
    let parentId : String
    //  parentId가 null이면 댓글 Long 값이 들어가면 대댓글(해당 parentId의 댓글에 종속되는)
}

struct addCommentResponse: Decodable {
    let commentId : Int
    let createdAt : String
    let updateAt : String
}

