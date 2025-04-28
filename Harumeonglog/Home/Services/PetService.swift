//
//  PetAPI.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/11/25.
//

import Alamofire


enum PetService {
    
    //MARK: GET /pets - 실제 API 요청 함수
    static func fetchPets(token: String? = nil, completion: @escaping (Result<PetResponse, AFError>) -> Void) {
        let endpoint = "/pets?cursor=0&size=10" // 기본 cursor=0, size=10 포함
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    
    //MARK: PATCH /pets/current
    static func updateCurrentPet(petId: Int, token: String, completion: @escaping (Result<UpdateCurrentPetResponse, AFError>) -> Void) {
        let endpoint = "/pets/current"
        let parameters = UpdateCurrentPetRequest(petId: petId)
        APIClient.patchRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
}

