//
//  FCMService.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/27/25.
//

import Alamofire

enum FCMService {
    
    static func sendFCM(fcm: String,
                 completion: @escaping(Result<HaruResponse<HaruEmptyResult>, AFError>) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        let endpoint = "/api/v1/members/fcm-tokens"
        APIClient.patchRequest(
            endpoint: endpoint,
            parameters: ["fcmToken": fcm],
            token: accessToken,
            completion: completion)
    }
}
