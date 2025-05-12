//
//  KakaoLoginService.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/18/25.
//

import Alamofire
import KakaoSDKAuth
import Foundation

class AuthAPIService {
    
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
                case AuthCode.COMMON200.rawValue:
                    print("access token is \(response.result!.accessToken)")
                    print("refresh token is \(response.result!.refreshToken)")
                    _ = KeychainService.add(key: K.Keys.accessToken, value: response.result!.accessToken)
                    _ = KeychainService.add(key: K.Keys.refreshToken, value: response.result!.refreshToken)
                    RootViewControllerService.toBaseViewController()
                case AuthCode.AUTH400.rawValue:
                    print("\(response.code) : OAuth 토큰 만료")
                default:
                    break
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func logout(completion: @escaping (AuthCode) -> Void) {
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
    
    static func revoke(completion: @escaping (AuthCode) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        APIClient.deleteRequest(
            endpoint: "/api/v1/members",
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
                print("revoke decoding failed: \(failure)")
            }
        }
    }
    
    static func reissue(completion: @escaping (AuthCode) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        guard let refreshToken = KeychainService.get(key: K.Keys.refreshToken) else { return }
        APIClient.postRequest(
            endpoint: "/api/v1/auth/reissue",
            parameters: ["refreshToken": refreshToken],
            token: accessToken
        ) { (response: Result<HaruResponse<ReissueResult>, AFError>) in
            switch response {
            case .success(let success):
                switch success.code {
                case AuthCode.COMMON200.rawValue:
                    let _ = KeychainService.update(key: K.Keys.accessToken, value: success.result!.accessToken)
                    completion(.COMMON200)
                case AuthCode.AUTH400.rawValue:
                    completion(.AUTH400)
                default:
                    print("undefined code, \(success.code)")
                }
            case .failure(let failure):
                print("revoke decoding failed: \(failure)")
            }
        }
    }
    
}

enum AuthCode: String {
    case COMMON200, AUTH400
}

struct LoginResult: Codable {
    let memberId: Int
    let accessToken: String
    let refreshToken: String
}

struct ReissueResult: Codable {
    let accessToken: String
}
