//
//  SettingAPI.swift
//  Harumeonglog
//
//  Created by 이승준 on 5/12/25.
//

import Alamofire

enum SettingCode: String {
    case COMMON200, AUTH400
}

class SettingAPIService {
    
    static func getSetting(completion: @escaping (SettingCode) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        APIClient.postRequestWithoutParameters(
            endpoint: "/api/v1/auth/logout",
            token: accessToken
        ) { (response: Result<HaruResponse<String>, AFError>) in
            switch response {
            case .success(let success):
                switch success.code {
                case AuthCode.COMMON200.rawValue:
                    completion(.COMMON200)
                case AuthCode.AUTH400.rawValue:
                    completion(.AUTH400)
                default:
                    print("undefined code, \(success.code)")
                }
            case .failure(let failure):
                print("logout decoding failed: \(failure)")
            }
        }
    }
    
}
