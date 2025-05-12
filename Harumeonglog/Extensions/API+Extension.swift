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
            "Content-Type": "application/json"
        ]
        // 토큰 값이 전달되면 인증 토큰 포함 (보안유지를 위해 매번 권한 확인)
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
    
    // 공통 GET 요청 함수
    static func getRequest<T: Decodable>(endpoint: String, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 GET 요청 함수 (parameters 추가)
    // Parameter: 서버에 요청할 때 필요한 추가 정보나 데이터
    static func getRequest<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(withToken: token)
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }

    
    // 공통 POST 요청 함수
    // T: Decodable로 응답으로 받을 데이터 타입, U: Encodable로 요청에 포함될 파라미터 타입
    // completion: @escaping (Result<T, AFError>) -> Void
        // 비동기 작업의 결과를 처리하기 위한 클로저입니다. 요청이 성공하면 Result의 성공 케이스에 응답 데이터 T가 포함되고, 실패하면 AFError 객체가 포함됩니다.
        // @escaping 키워드는 이 클로저가 함수 종료 후에도 계속해서 사용할 수 있음을 나타냅니다.

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

