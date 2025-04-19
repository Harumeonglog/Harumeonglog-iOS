//
//  PhotoService.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/12/25.
//

import Alamofire


enum PhotoService {
    
    //MARK: GET /pet-images/{petId} 특정 반려동물의 이미지 목록 불러오기
    static func fetchPetImages(
        petId: Int,
        cursor: Int = 0,
        size: Int = 10,
        token: String? = nil,
        completion: @escaping (Result<PetImageListResponse, AFError>) -> Void
    ) {
        let endpoint = "/pet-images/\(petId)?cursor=\(cursor)&size=\(size)"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    //MARK: POST /pet-images/{petId} 새 이미지 업로드
    static func uploadPetImages(
        petId: Int,
        imageKeys: [String],
        token: String? = nil,
        completion: @escaping (Result<UploadPetImagesResponse, AFError>) -> Void
    ) {
        let endpoint = "/pet-images/\(petId)"
        let body = UploadPetImagesRequest(imageKeys: imageKeys)

        APIClient.postRequest(endpoint: endpoint, parameters: body, token: token, completion: completion)
    }
    
    // MARK: - DELETE /pet-images/{petId} 선택된 사진들 삭제
    static func deletePetImages(
        petId: Int,
        imageIds: [Int],
        token: String? = nil,
        completion: @escaping (Result<DeletePetImagesResponse, AFError>) -> Void
    ) {
        let endpoint = "/pet-images/\(petId)"
        let parameters = DeletePetImagesRequest(imageIds: imageIds)

        APIClient.deleteRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }
    
    //MARK: GET /pet-images/image/{imageId} 사진 상세 보기
    static func fetchImageDetail(
        imageId: Int,
        token: String? = nil,
        completion: @escaping (Result<PetImageDetailResponse, AFError>) -> Void
    ) {
        let endpoint = "/pet-images/image/\(imageId)"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
    //MARK: DELETE /pet-images/image/{imageId} 특정 이미지 삭제
    static func deleteImage(
        imageId: Int,
        token: String? = nil,
        completion: @escaping (Result<DeleteSingleImageResponse, AFError>) -> Void
    ) {
        let endpoint = "/pet-images/image/\(imageId)"
        APIClient.deleteRequest(endpoint: endpoint, token: token, completion: completion)
    }
    
}
