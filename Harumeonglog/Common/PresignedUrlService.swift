//
//  PresignedUrl.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/12/25.
//

import Alamofire
import UIKit

enum PresignedURLDomain: String {
    case pet = "PET"
    case post = "POST"
    case member = "MEMBER"
}

enum PresignedUrlService {
    // MARK: - POST /api/v1/s3/presigned-urls S3 이미지 PresignedUrl 발급
    static func getPresignedUrls(
        domain: PresignedURLDomain,
        entities: [PURLsRequestEntity],
        token: String? = nil,
        completion: @escaping (Result<HaruResponse<PUrlsResult>, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/s3/presigned-urls"
        let requestBody = PURLsRequestBody(
                domain: domain.rawValue,
                entities: entities
            )
        APIClient.postRequest(endpoint: endpoint, parameters: requestBody, token: token, completion: completion as (Result<HaruResponse<PUrlsResult>, AFError>) -> Void)
    }
    
}

// MARK: - POST /api/v1/s3/presigned-urls S3 이미지 PresignedUrl 발급
// request
struct PURLsRequestBody: Codable {
    let domain: String
    let entities: [PURLsRequestEntity]
}

struct PURLsRequestEntity: Codable {
    let entityId: Int
    let images: [PresignedUrlImage]
}

struct PresignedUrlImage: Codable {
    let filename: String
    let contentType: String
}

// response
struct PUrlsResult: Codable {
    let entities: [PUrlsEntity]
}

struct PUrlsEntity: Codable {
    let entityId: Int
    let images: [PresignedUrlResult]
}

struct PresignedUrlResult: Codable {
    let presignedUrl: String
    let imageKey: String
}


// MARK: presignedURL에 이미지 업로드하기 위한 메서드
extension UIViewController {
    func uploadImageToS3(imageData: Data, presignedUrl: URL, completion: @escaping (Result<Bool, Error>) -> Void) {
        var request = URLRequest(url: presignedUrl)
        request.httpMethod = "PUT" // S3 Presigned URL은 PUT 메소드 사용
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type") // 이미지 타입에 맞게 설정
        
        AF.upload(imageData, with: request)
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                if let statusCode = response.response?.statusCode,
                   (200...299).contains(statusCode) {
                    print("#uploadImageToS3: successful")
                    completion(.success(true))
                } else {
                    let error = NSError(
                        domain: "S3UploadError",
                        code: response.response?.statusCode ?? -1,
                        userInfo: [NSLocalizedDescriptionKey: "업로드 실패"]
                    )
                    print("#uploadImageToS3: \(error)")
                    completion(.failure(error))
                }
            }
    }
}

// 아래 내용은 삭제되어야함 Presigned 구버전 코드

extension PresignedUrlService {
    // MARK: - POST /api/v1/s3/presigned-urls S3 단일 이미지 PresignedUrl 발급
    static func fetchPresignedUrl(
        filename: String,
        contentType: String,
        domain: PresignedURLDomain,
        entityId: Int,
        token: String? = nil,
        completion: @escaping (Result<PresignedUrlSingleResponse, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/s3/presigned-urls"
        let body = PresignedUrlSingleRequest(
            image: PresignedUrlImage(filename: filename, contentType: contentType),
            domain: domain.rawValue,
            entityId: entityId
        )
        APIClient.postRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }
    
    //MARK: POST /api/v1/s3/presigned-urls/batch S3 복수 이미지 PresignedUrl 발급
    static func fetchBatchPresignedUrls(
        images: [PresignedUrlImage],
        domain: PresignedURLDomain,
        entityId: Int,
        token: String? = nil,
        completion: @escaping (Result<PresignedUrlBatchResponse, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/s3/presigned-urls/batch"
        let body = PresignedUrlBatchRequest(images: images, domain: domain.rawValue, entityId: entityId)
        APIClient.postRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }
}

//MARK: POST /api/v1/s3/presigned-urls S3 단일 이미지 PresignedUrl 발급
struct PresignedUrlSingleRequest: Codable {
    let image: PresignedUrlImage
    let domain: String
    let entityId: Int
}

struct PresignedUrlSingleResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PresignedUrlResultOrString
}

enum PresignedUrlResultOrString: Decodable {
    case result(PresignedUrlResult)
    case message(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let result = try? container.decode(PresignedUrlResult.self) {
            self = .result(result)
        } else if let message = try? container.decode(String.self) {
            self = .message(message)
        } else {
            throw DecodingError.typeMismatch(
                PresignedUrlResultOrString.self,
                .init(codingPath: decoder.codingPath, debugDescription: "Unexpected type for result field.")
            )
        }
    }
}

//MARK: POST /api/v1/s3/presigned-urls/batch S3 복수 이미지 PresignedUrl 발급
struct PresignedUrlBatchRequest: Codable {
    let images: [PresignedUrlImage]
    let domain: String
    let entityId: Int
}

struct PresignedUrlBatchResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PresignedUrlBatchResult
}

struct PresignedUrlBatchResult: Codable {
    let images: [PresignedUrlResult]
}




