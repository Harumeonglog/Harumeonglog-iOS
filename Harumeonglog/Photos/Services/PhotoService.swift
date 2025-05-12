//
//  PhotoService.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/12/25.
//

import Alamofire


enum PhotoService {
    
    //MARK: POST /api/v1/pets/images 이미지 저장
    static func saveImages(
        petId: Int,
        imageKeys: [String],
        token: String? = nil,
        completion: @escaping (Result<SaveImagesResponse, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/pets/images"
        let body = SaveImagesRequest(petId: petId, imageKeys: imageKeys)
        
        APIClient.postRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }
    
    //MARK: GET /api/v1/pets/{petId}/images 특정 반려동물의 이미지 목록 불러오기
    static func fetchPetImages(
        petId: Int,
        cursor: Int = 0,
        size: Int = 10,
        token: String? = nil,
        completion: @escaping (Result<PetImageListResponse, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/pets/\(petId)/images"
        let parameters: [String: Any] = [
            "cursor": cursor,
            "size": size
        ]
        
        APIClient.getRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
    //MARK: GET /api/v1/pets/images/{imageId} 단일 이미지 조회
    static func fetchImageDetail(
        imageId: Int,
        token: String? = nil,
        completion: @escaping (Result<PetImageDetailResponse, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/pets/images/\(imageId)"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    //MARK: DELETE /api/v1/pets/images/{imageId} 단일 이미지 삭제
    static func deleteImage(
        imageId: Int,
        token: String? = nil,
        completion: @escaping (Result<DeleteSingleImageResponse, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/pets/images/\(imageId)"
        APIClient.deleteRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    //MARK: DELETE /api/v1/pets/{petId}/images 다중 이미지 삭제
    static func deleteMultipleImage(
        petId: Int,
        imageIds: [Int],
        token: String? = nil,
        completion: @escaping (Result<DeleteImagesResponse, AFError>) -> Void
    ) {
        let endpoint = "/api/v1/pets/\(petId)/images"
        let parameters = DeleteImagesRequest(imageIds: imageIds)
        APIClient.deleteRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
    
    
    
    
    

}
