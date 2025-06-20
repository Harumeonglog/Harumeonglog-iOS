//
//  PetModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/11/25.
//

//MARK: GET /api/v1/pets - 반려동물 목록 조회
struct PetResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: PetResultOrString?
}

enum PetResultOrString: Decodable {
    case result(PetResult)
    case message(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let result = try? container.decode(PetResult.self) {
            self = .result(result)
        } else if let message = try? container.decode(String.self) {
            self = .message(message)
        } else {
            throw DecodingError.typeMismatch(
                PetResultOrString.self,
                .init(codingPath: decoder.codingPath, debugDescription: "result 필드 디코딩 실패")
            )
        }
    }
}

struct PetResult: Decodable {
    let pets: [Pet]
    let cursor: Int?
    let hasNext: Bool
}

struct Pet: Codable {
    let role: String
    let petId: Int
    let name: String
    let size: String
    let type: String
    let gender: String
    let birth: String?
    let mainImage: String?
    var people: [PetMember]?
}

struct PetMember: Codable {
    let id: Int
    let name: String
    let role: String
    let image: String
}

//MARK: GET /api/v1/pets/active - 현재 펫 변경 시 보유 펫 조회
struct ActivePetsResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ActivePetsResultOrString?
}

enum ActivePetsResultOrString: Decodable {
    case result(ActivePetsResult)
    case message(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let result = try? container.decode(ActivePetsResult.self) {
            self = .result(result)
        } else if let message = try? container.decode(String.self) {
            self = .message(message)
        } else {
            throw DecodingError.typeMismatch(
                ActivePetsResultOrString.self,
                .init(codingPath: decoder.codingPath, debugDescription: "result 필드 디코딩 실패")
            )
        }
    }
}

struct ActivePetsResult: Decodable {
    let pets: [ActivePets]
}

struct ActivePets: Decodable {
    let petId: Int
    let name: String
    let mainImage: String?
}

//MARK: /api/v1/pets/{petId}/status/active - 현재 펫 변경
struct ActivePetResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

//MARK: /api/v1/pets/active/primary - 현재 펫 정보 조회
struct ActivePetInfoResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ActivePetInfoResult?
}

struct ActivePetInfoResult: Decodable {
    let petId: Int
    let name: String
    let mainImage: String?
    let gender: String
    let birth: String
}

//MARK: POST/api/v1/pets 펫 추가
//MARK: PATCH/api/v1/pets/{petId} 펫 정보 수정
struct PetParameter {
    let name: String
    let size: String // SMALL, BIG, MIDDLE
    let type: String
    let gender: String // MALE, FEMALE
    let birth: String
    let imageKey: String
}

struct PetPostResponse : Codable {
    let petId: Int?
    let createdAt: String?
    let updatedAt: String?
}

struct PetPatchResponse : Codable {
    let petId: Int
    let name: String
    let size: String
    let type: String
    let gender: String
    let role: String
    let birth: String
    let mainImage: String
    let updatedAt: String
}

//MARK: GET/api/v1/pets 펫 목록 조회
struct PetListResponse: Codable {
    let pets: [Pet]?
    let cursor: Int?
    let hasNext: Bool
}
