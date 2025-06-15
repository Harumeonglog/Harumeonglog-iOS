//
//  WalkModel.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/14/25.
//

import Foundation

struct WalkStartRequest : Codable {
    let petId: [Int]
    let memberId: [Int]
    let startLatitude: Double
    let startLongitude: Double
}

struct WalkStartResponse : Codable {
    let walkId: Int
    let trackId: Int
    let createdAt: String
    let updatedAt: String
}


struct WalkPauseResponse : Codable {
    let walkId: Int
    let status: String
    let updatedAt: String
}

struct WalkResumeRequest: Codable {
    let latitude: Double
    let longitude: Double
}

struct WalkResumeResponse : Codable {
    let walkId: Int
    let trackId: Int
    let status: String
    let updatedAt: String
}


struct WalkEndRequest : Codable {
    let time: Int
    let distance: Int
}


struct WalkEndResponse: Codable {
    let walkId: Int
    let updatedAt: String
}


struct WalkShareResponse: Codable {
    let walkId: Int
    let isShared: Bool
    let updatedAt: String
}
