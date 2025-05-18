//
//  commentServiceModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 5/12/25.
//

import Foundation


//MARK: 댓글 조회 API
struct CommentRequest: Codable {
    let postId : Int
    let cursor : Int
    let size : Int
}

struct CommentResponse: Codable {
    let items : [CommentItem?]
    let hasNext : Bool
    let cursor : Int?
}

struct CommentItem: Codable {
    let commentId : Int
    let content : String?
    let memberInfoResponse: MemberInfoResponse
    let commentcommentResponseList : [CommentcommentResponse]   // 대댓글 리스트
}

struct CommentcommentResponse : Codable {
    let commentId : Int
    let content : String
    let memberInfoResponse: MemberInfoResponse
}


// MARK: 댓글 생성 API
struct AddCommentRequest: Codable {
    let content : String?
    let parentId : Int?
    //  parentId가 null이면 댓글 Long 값이 들어가면 대댓글(해당 parentId의 댓글에 종속되는)
}

struct AddCommentResponse: Codable {
    let commentId : Int
    let createAt : String
    let updateAt : String
}

