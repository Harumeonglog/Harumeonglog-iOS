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
        if let result = try? container.decode(PetImageListResult.self) {
            self = .result(result)
        } else if let message = try? container.decode(String.self) {
            self = .message(message)
        } else {
            throw DecodingError.typeMismatch(
                PetImageListResultOrString.self,
                .init(codingPath: decoder.codingPath, debugDescription: "Unexpected type for result field.")
            )
        }
    }
}

struct PetImageListResult: Codable {
    let images:[PetImage]
    let cursor: Int
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

//MARK: DELETE /pet-images/{petId} 앨범 내 모든 이미지 삭제
struct DeletePetImagesRequest : Codable {
    let imageIds : [Int]
}

struct DeletePetImagesResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

//MARK: GET /pet-images/image/{imageId} 사진 상세 보기 용
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

//MARK: DELETE /pet-images/image/{imageId} 특정 이미지 삭제
struct DeleteSingleImageResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}
