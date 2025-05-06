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

// enum으로 분기 처리
enum PetResultOrString: Decodable {
    case result(PetResult)
    case message(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let result = try container.decode(PetResult.self)
            self = .result(result)
        } catch let resultError {
            do {
                let message = try container.decode(String.self)
                self = .message(message)
            } catch let messageError {
                throw DecodingError.typeMismatch(
                    PetResultOrString.self,
                    .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unexpected type for result field. Tried PetResult (\(resultError)) and String (\(messageError))."
                    )
                )
            }
        }
    }
}

struct PetResult: Decodable {
    let pets: [Pet]
    let cursor: Int?
    let hasNext: Bool
}

struct Pet: Decodable {
    let role: String
    let petId: Int
    let name: String
    let size: String
    let type: String
    let gender: String
    let birth: String?
    let mainImage: String?
    let people: [PetMember]?
}

struct PetMember: Decodable {
    let id: Int
    let name: String
    let role: String
    let image: String
}
