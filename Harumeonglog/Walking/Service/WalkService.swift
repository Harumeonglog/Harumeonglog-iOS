//
//  WalkService.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/19/25.
//

import Foundation
import Alamofire

class WalkService {
    
    func walkStart(
        petId: [Int],
        memberId: [Int],
        startLatitude: Double,
        startLongitude: Double,
        token: String,
        completion: @escaping (Result<HaruResponse<WalkStartResponse>, AFError>) -> Void
    ) {
        
        let endpoint = "/api/v1/walks"
        let body = WalkStartRequest(petId: petId, memberId: memberId, startLatitude: startLatitude, startLongitude: startLongitude)
        
        print("산책 시작 body: \(body)")
        APIClient.postRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }
    
    func walkPause(
        walkId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<WalkPauseResponse>, AFError>) -> Void
    ) {
        
        let endpoint = "/api/v1/walks/\(walkId)/pause"
        APIClient.patchRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    
    func walkResume(
        walkId: Int,
        latitude: Double,
        longitude: Double,
        token: String,
        completion: @escaping (Result<HaruResponse<WalkResumeResponse>, AFError>) -> Void
    ) {
        
        let endpoint = "/api/v1/walks/\(walkId)/resume"
        let body = WalkResumeRequest(latitude: latitude, longitude: longitude)
        
        APIClient.patchRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }

    

    func walkEnd(
        walkId: Int,
        time: Int,
        distance: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<WalkEndResponse>, AFError>) -> Void
    ) {
        
        let endpoint = "/api/v1/walks/\(walkId)/end"
        let body = WalkEndRequest(time: time, distance: distance)
        
        print("산책 종료 body: \(body)")
        APIClient.patchRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }
    
    
    func walkSave(
        walkId: Int,
        title: String?,
        token: String,
        completion: @escaping (Result<HaruResponse<WalkSaveResponse>, AFError>) -> Void
    ) {
        
        let endpoint = "/api/v1/walks/\(walkId)"
        let body = WalkSaveRequest(title: title)
        
        APIClient.patchRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }
    
    
    func walkShare(
        walkId: Int,
        token: String,
        completion: @escaping (Result<HaruResponse<WalkShareResponse>, AFError>) -> Void
    ){
        let endpoint = "/api/v1/walks/\(walkId)/share"
        APIClient.patchRequest(endpoint: endpoint, token: token, completion: completion)
    }
}
