//
//  PetAPI.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/11/25.
//

import Alamofire


enum PetService {
    
    //MARK: GET /api/v1/pets - 반려동물 목록 조회
    static func fetchPets(token: String? = nil, size: Int = 10, cursor: Int? = 0, completion: @escaping (Result<PetResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/pets"
        var parameters: [String: Any] = ["size": size]
        if let cursor = cursor {
            parameters["cursor"] = cursor
        }
        APIClient.getRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
    //MARK: GET /api/v1/pets/{petId}/images - 특정 반려동물의 이미지 목록 조회
    static func fetchPetImages(petId: Int, cursor: Int = 0, size: Int = 10, token: String? = nil, completion: @escaping (Result<PetImageListResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/pets/\(petId)/images?cursor=\(cursor)&size=\(size)"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    //MARK: GET /api/v1/pets/active - 현재 펫 변경 시 보유 펫 조회
    static func fetchActivePets(token: String, size: Int = 10, cursor: Int? = 0, completion: @escaping (Result<ActivePetsResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/pets/active"
        var parameters: [String: Any] = ["size": size]
        if let cursor = cursor {
            parameters["cursor"] = cursor
        }
        APIClient.getRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
    //MARK: /api/v1/pets/{petId}/status/active - 현재 펫 변경
    static func UpdateActivePet(petId: Int, token: String, completion: @escaping (Result<ActivePetResponse, AFError>)-> Void) {
        let endpoint = "/api/v1/pets/\(petId)/status/active"
        APIClient.patchRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    //MARK: /api/v1/pets/active/primary - 현재 펫 정보 조회
    static func ActivePetInfo(token: String, completion: @escaping(Result<ActivePetInfoResponse, AFError>)-> Void){
        let endpoint = "/api/v1/pets/active/primary"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
}

extension PetService {
    
    //MARK: GET/api/v1/pets 펫 목록 조회
    static func getPets(cursor: Int, token: String, completion: @escaping(Result<HaruResponse<PetListResponse>, AFError>) -> Void) {
        let endpoint = "/api/v1/pets?cursor=\(cursor)&size=10"
        APIClient.getRequestWithoutParameters(endpoint: endpoint, token: token, completion: completion)
    }
    
    //MARK: POST/api/v1/pets 펫 추가
    static func postPet(newInfo: PetParameter, token: String, completion: @escaping(Result<HaruResponse<PetPostResponse?>, AFError>) -> Void) {
        let endpoint = "/api/v1/pets"
        APIClient.postRequest(endpoint: endpoint,
                              parameters: ["name": newInfo.name,
                                           "size": newInfo.size,
                                           "type": newInfo.type,
                                           "gender": newInfo.gender,
                                           "birth": newInfo.birth,
                                           "mainImageKey": newInfo.imageKey],
                              token: token,
                              completion: completion)
    }
    
    //MARK: PATCH/api/v1/pets/{petId} 펫 정보 수정
    static func patchPet(petId: Int, token: String, newInfo: PetParameter, completion: @escaping(Result<HaruResponse<PetPatchResponse>, AFError>) -> Void) {
        let endpoint = "/api/v1/pets/\(petId)"
        APIClient.patchRequest(endpoint: endpoint,
                               parameters: ["name": newInfo.name,
                                            "size": newInfo.size,
                                            "type": newInfo.type,
                                            "gender": newInfo.gender,
                                            "birth": newInfo.birth,
                                            "newMainImageKey": newInfo.imageKey],
                               token: token,
                               completion: completion)
    }
    
    //MARK: DELETE/api/v1/pets/{petId} 펫 삭제
    static func deletePet(petId: Int, token: String, completion: @escaping(Result<HaruResponse<String>, AFError>) -> Void) {
        let endpoint = "/api/v1/pets/\(petId)"
        APIClient.deleteRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    static func deletePetMember(memberId: Int, petId: Int, token: String, completion: @escaping(Result<HaruResponse<HaruEmptyResult>, AFError>) -> Void) {
        let endpoint = "/api/v1/pets/\(petId)"
        APIClient.deleteRequest(endpoint: endpoint, token: token, completion: completion)
    }
}


