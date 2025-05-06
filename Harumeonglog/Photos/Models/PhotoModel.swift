//
//  PhotoModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/12/25.
//

//MARK: GET /pet-images/{petId} 특정 반려동물의 이미지 목록 불러오기
struct PetImageListResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PetImageListResultOrString?
}

enum PetImageListResultOrString: Decodable {
    case result(PetImageListResult)
    case message(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let result = try container.decode(PetImageListResult.self)
            self = .result(result)
        } catch let resultError {
            do {
                let message = try container.decode(String.self)
                self = .message(message)
            } catch let messageError {
                throw DecodingError.typeMismatch(
                    PetImageListResultOrString.self,
                    .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unexpected type for result field. Tried PetImageListResult (\(resultError)) and String (\(messageError))."
                    )
                )
            }
        }
    }
}

struct PetImageListResult: Codable {
    let images:[PetImage]
    let cursor: Int?
    let hasNext: Bool
}

struct PetImage: Codable {
    let imageId: Int
    let imageKey: String
    let createdAt: String
}

//MARK: POST /pet-images/{petId} 새 이미지 업로드
struct UploadPetImagesRequest: Codable {
    let imageKeys: [String]
}

struct UploadPetImagesResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UploadResult
}

struct UploadResult: Codable {
    let imageIds: [Int]
}

//MARK: DELETE /api/v1/pets/{petId}/images 다중 이미지 삭제
struct DeleteImagesRequest : Codable {
    let imageIds : [Int]
}

struct DeleteImagesResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

//MARK: GET /api/v1/pets/images/{imageId} 단일 이미지 조회
struct PetImageDetailResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PetImageDetail
}

struct PetImageDetail: Codable {
    let imageId: Int
    let imageKey: String
    let createdAt: String
}

//MARK: DELETE /api/v1/pets/images/{imageId} 특정 이미지 삭제

struct DeleteSingleImageResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

//MARK: POST /api/v1/s3/presigned-urls S3 단일 이미지 PresignedUrl 발급
struct PresignedUrlSingleRequest: Codable {
    let image: PresignedUrlImage
    let domain: String
    let entityId: Int
}

struct PresignedUrlSingleResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let presignedUrl: String
    let imageKey: String
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


//MARK: POST /api/v1/pets/images S3 업로드 후 이미지 저장
struct SaveImagesRequest: Codable {
    let petId: Int
    let imageKeys: [String]
}

struct SaveImagesResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SaveImagesResult?
}

struct SaveImagesResult: Codable {
    let imageIds: [Int]
    let createdAt: String
    let updatedAt: String
}
