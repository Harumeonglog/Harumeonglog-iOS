//
//  NoticeService.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/18/25.
//

import Alamofire

enum NoticeService {
    
    static func getNoticies(cursor: Int, token: String, completion: @escaping(Result<HaruResponse<NoticesResult>, AFError>) -> Void) {
        let endpoint = "/api/v1/noticies?cursor=\(cursor)&size=10"
        APIClient.getRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
    
    static func deletePet(noticeID: Int, token: String, completion: @escaping(Result<HaruResponse<HaruEmptyResult>, AFError>) -> Void) {
        let endpoint = "/api/v1/noticies/\(noticeID)"
        APIClient.deleteRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
}
