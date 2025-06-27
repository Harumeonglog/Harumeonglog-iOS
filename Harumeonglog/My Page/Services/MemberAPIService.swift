//
//  SettingAPI.swift
//  Harumeonglog
//
//  Created by 이승준 on 5/12/25.
//

import Alamofire

enum MemberCode: String {
    case COMMON200, AUTH400, AUTH401, ERROR500
}

struct SettingResult: Codable {
    let memberId: Int?
    let morningAlarm: Bool
    let eventAlarm: Bool
    let articleLikeAlarm: Bool
    let commentAlarm: Bool
    let updatedAt: String?
}

struct SettingParameter: Codable {
    let morningAlarm: Bool
    let eventAlarm: Bool
    let articleLikeAlarm: Bool
    let commentAlarm: Bool
}

enum InfoCode: String {
    case COMMON200, AUTH400, AUTH401, ERROR500
}

struct InfoResult: Codable {
    let memberId: Int
    let email: String?
    let nickname: String?
    let image: String?
    let updatedAt: String?
}

typealias UserInfo = InfoResult

struct InfoParameters {
    let imageKey: String?
    let nickname: String?
}

class MemberAPIService {
    
    static var userInfo: UserInfo?
    
    static func getSetting(completion: @escaping (MemberCode, SettingResult?) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        APIClient.getRequest(
            endpoint: "/api/v1/members/setting",
            token: accessToken
        ) { (response: Result<HaruResponse<SettingResult>, AFError>) in
            switch response {
            case .success(let apiResponse):
                switch apiResponse.code {
                case MemberCode.COMMON200.rawValue:
                    completion(.COMMON200, apiResponse.result)
                case MemberCode.AUTH400.rawValue:
                    completion(.AUTH400, nil)
                case MemberCode.AUTH401.rawValue:
                    completion(.AUTH401, nil)
                default:
                    completion(.ERROR500, nil)
                    print("undefined code, \(apiResponse.code)")
                }
            case .failure(let failure):
                completion(.ERROR500, nil)
                print(response)
                print("get setting decoding failed: \(failure)")
            }
        }
    }
    
    static func patchSetting(param: SettingParameter , completion: @escaping (MemberCode) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        APIClient.patchRequest(
            endpoint: "/api/v1/members/setting",
            parameters: [
                "morningAlarm": param.morningAlarm,
                "eventAlarm": param.eventAlarm,
                "articleLikeAlarm": param.articleLikeAlarm,
                "commentAlarm": param.commentAlarm
            ],
            token: accessToken
        ) { (response: Result<HaruResponse<SettingResult>, AFError>) in
            switch response {
            case .success(let apiResponse):
                switch apiResponse.code {
                case MemberCode.COMMON200.rawValue:
                    completion(.COMMON200)
                case MemberCode.AUTH400.rawValue:
                    completion(.AUTH400)
                case MemberCode.AUTH401.rawValue:
                    completion(.AUTH401)
                default:
                    completion(.ERROR500)
                    print("undefined code, \(apiResponse.code)")
                }
            case .failure(let failure):
                completion(.ERROR500)
                print("patch setting decoding failed: \(failure)")
            }
        }
    }
    
    static func getInfo(completion: @escaping (InfoCode, UserInfo?) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        APIClient.getRequest(
            endpoint: "/api/v1/members/info",
            token: accessToken
        ) { (response: Result<HaruResponse<InfoResult>, AFError>) in
            switch response {
            case .success(let apiResponse):
                switch apiResponse.code {
                case MemberCode.COMMON200.rawValue:
                    print(apiResponse.result as Any)
                    completion(.COMMON200, apiResponse.result)
                    self.userInfo = apiResponse.result
                case MemberCode.AUTH400.rawValue:
                    completion(.AUTH400, nil)
                case MemberCode.AUTH401.rawValue:
                    completion(.AUTH401, nil)
                default:
                    completion(.ERROR500, nil)
                    print("undefined code, \(apiResponse.code)")
                }
            case .failure(let failure):
                completion(.ERROR500, nil)
                print(response)
                print("get setting decoding failed: \(failure)")
            }
        }
    }
    
    static func patchInfo(param: InfoParameters, completion: @escaping (InfoCode) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { return }
        APIClient.patchRequest(
            endpoint: "/api/v1/members/info",
            parameters: [
                "imageKey": param.imageKey,
                "nickname": param.nickname,
            ],
            token: accessToken
        ) { (response: Result<HaruResponse<InfoResult>, AFError>) in
            switch response {
            case .success(let apiResponse):
                switch apiResponse.code {
                case MemberCode.COMMON200.rawValue:
                    completion(.COMMON200)
                case MemberCode.AUTH400.rawValue:
                    completion(.AUTH400)
                case MemberCode.AUTH401.rawValue:
                    completion(.AUTH401)
                default:
                    completion(.ERROR500)
                    print("undefined code, \(apiResponse.code)")
                }
            case .failure(let failure):
                completion(.ERROR500)
                print("patch info decoding failed: \(failure)")
            }
        }
    }
    
}
