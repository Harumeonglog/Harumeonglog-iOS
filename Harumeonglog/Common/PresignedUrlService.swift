//
//  PresignedUrl.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/12/25.
//

import Alamofire

enum PresignedURLDomain: String {
    case pet = "PET"
    case post = "POST"
    case member = "MEMBER"
}

enum PresignedUrlService {
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

struct PresignedUrlResult: Codable {
    let presignedUrl: String
    let imageKey: String
}

struct PresignedUrlImage: Codable {
    let filename: String
    let contentType: String
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
    let presignedUrls: [PresignedUrlResult]
}
