//
//  WalkRecommendService.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/19/25.
//

import Foundation
import Alamofire


class WalkRecommendService {
    
    func fetchWalkRecommends(
        sort: String,
        cursor: Int,
        size: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<WalkRecommendResponse>, AFError>) -> Void
    ) {
        
        let endpoint = "/api/v1/walks"
        var parameters: [String: Any] = [
            "sort": sort,
            "cursor": cursor,
            "size": size
        ]
        APIClient.getRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
    
    func likeWalkRecommend(
        walkId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<WalkRecommendLikeResponse>, AFError>) -> Void
    ) {
        
        let endpoint = "/api/v1/walks/\(walkId)"
        APIClient.postRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
    
    
    func fetchWalkRecommendDetail(
        walkId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<WalkRecommendDetailResponse>, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/walks/\(walkId)"
        APIClient.getRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }

}
