//
//  PetModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/11/25.
//

//MARK: GET /pets 
struct PetResponse: Decodable {
    let isSuccess : Bool
    let code: String
    let message : String
    let result : PetResultOrString?
}

// enum으로 분기 처리
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
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unexpected result type")
            )
        }
    }
}

struct PetResult : Decodable {
    let pets: [Pet]
    let cursor: Int
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
}


//MARK: PATCH /pets/current
struct UpdateCurrentPetRequest: Encodable {
    let petId: Int
}

struct UpdateCurrentPetResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: CurrentPetResult?
}

struct CurrentPetResult: Decodable {
    let petId: Int
    let name: String
}
