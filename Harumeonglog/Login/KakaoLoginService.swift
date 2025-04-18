//
//  KakaoLoginService.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/18/25.
//

import Alamofire
import KakaoSDKAuth
import Foundation

class KakaoLoginService {
    
    static func login(oauth: OAuthToken) {
        let url = K.haruURL + "/api/v1/auth/KAKAO/login"
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = ["idToken": oauth.idToken!]
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: HaruResponse<LoginResult>.self) { response in
            switch response.result {
            case .success(let response):
                switch response.code {
                case LoginCode.COMMON200.rawValue:
                    _ = KeychainService.add(key: K.Keys.accessToken, value: response.result!.accessToken)
                    _ = KeychainService.add(key: K.Keys.refreshToken, value: response.result!.refreshToken)
                    RootViewControllerService.toBaseViewController()
                case LoginCode.AUTH400.rawValue:
                    print("\(response.code) : OAuth 토큰 만료")
                default:
                    break
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

struct LoginResult: Codable {
    let memberId: Int
    let accessToken: String
    let refreshToken: String
}

enum LoginCode: String {
    case COMMON200, AUTH400
}
