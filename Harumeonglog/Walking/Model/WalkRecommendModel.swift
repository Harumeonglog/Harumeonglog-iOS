//
//  WalkRecommendModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/14/25.
//

import Foundation

struct WalkRecommendResponse: Codable {
    let items : [WalkRecommendItem]?
    let hasNext : Bool
    let cursor: Int?
}

struct WalkRecommendItem: Codable {
    let id: Int
    let title: String?
    let walkLikeNum: Int
    let distance: String?
    let time: Int
    let memberNickname: String
    let isLike: Bool
}

struct WalkRecommendLikeResponse: Codable {
    let walkId: Int
    let walkLikeNum: Int
    let updatedAt: String
}


struct WalkRecommendDetailResponse: Codable {
    let id: Int
    let title: String
    let walkLikeNum: Int
    let distance: String
    let time: Int
    let memberNickname: String
    let isLike: Bool
    let tracks: [WalkRecommendTrack]
}

struct WalkRecommendTrack: Codable {
    let trackId: Int
    let positions: [WalkRecommendPosition]
    
    struct WalkRecommendPosition: Codable {
        let latitude: Double
        let longitude: Double
    }
}

