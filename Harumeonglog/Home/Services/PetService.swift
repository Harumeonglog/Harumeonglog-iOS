//
//  PetAPI.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/11/25.
//

import Alamofire


enum PetService {
    
    //MARK: GET /api/v1/pets - 반려동물 목록 조회
    static func fetchPets(token: String? = nil, completion: @escaping (Result<PetResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/pets"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    //MARK: GET /api/v1/pets/{petId}/images - 특정 반려동물의 이미지 목록 조회
    static func fetchPetImages(petId: Int, cursor: Int = 0, size: Int = 10, token: String? = nil, completion: @escaping (Result<PetImageListResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/pets/\(petId)/images?cursor=\(cursor)&size=\(size)"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
}
