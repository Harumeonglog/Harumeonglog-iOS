//
//  API+Extension.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import Alamofire

// APIClient 클래스 정의
class APIClient {
    static let shared = APIClient()
    private init() {}                // 외부에서 추가 인스턴스 생성 불가
}

extension APIClient {
    
    // Base URL 설정
    private static let baseURL = "https://api.haru-official.click"
    
    // 공통 헤더 생성 함수
    private static func getHeaders(withToken token: String? = nil) -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"  // 없어도 되는데, 있으면 좋은 것
        ]
        // 토큰 값이 전달되면 인증 토큰 포함 (보안유지를 위해 매번 권한 확인)
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
    
    // 공통 GET 요청 함수
    static func getRequestWithoutParameters<T: Decodable>(endpoint: String, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 GET 요청 함수 (parameters 추가)
    static func getRequest<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 GET 요청 함수 (requestBody 추가)
    static func getRequestWithRequestBody<T: Decodable, U: Encodable>(endpoint: String, parameters: U, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }


    
    // 공통 POST 요청 함수
    static func postRequest<T: Decodable, U: Encodable>(endpoint: String, parameters: U, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 POST 요청 함수 (parameters가 필요없을 때)
    static func postRequestWithoutParameters<T: Decodable>(endpoint: String, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // PUT 요청 함수
    static func putRequest<T: Decodable>(endpoint: String, parameters: Parameters? = nil, token: String, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }

    // 공통 PUT 요청 함수 (Encodable 파라미터 버전)
    static func putRequest<T: Decodable, U: Encodable>(endpoint: String, encodable: U, token: String, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        AF.request(url, method: .put, parameters: encodable, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
    
    // 공통 DELETE 요청 함수
    static func deleteRequest<T: Decodable>(endpoint: String, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        
        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }

    // 공통 DELETE 요청 함수 (body 포함)
    static func deleteRequest<T: Decodable, U: Encodable>(
        endpoint: String,
        parameters: U,
        token: String? = nil,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)

        AF.request(url,
                   method: .delete,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate()
        .responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }

    // 공통 PATCH 요청 함수
    static func patchRequest<T: Decodable, U: Encodable>(endpoint: String, parameters: U, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)

        AF.request(url, method: .patch, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    static func patchRequest<T: Decodable>(endpoint: String, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)

        AF.request(url, method: .patch, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
