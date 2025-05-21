//
//  HomePetViewModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
//



import Foundation
import Alamofire

class HomePetViewModel {

    func fetchActivePets(completion: @escaping (ActivePetsResult?) -> Void) {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 존재하지 않음")
            completion(nil)
            return
        }

        PetService.fetchActivePets(token: token) { result in
            switch result {
            case .success(let response):
                switch response.result {
                case .result(let activePetsResult):
                    completion(activePetsResult)
                    print("반려동물 조회 성공")
                default:
                    print("서버 응답이 result 형식이 아님")
                    completion(nil)
                }
            case .failure(let error):
                print("반려동물 조회 실패: \(error)")
                completion(nil)
            }
        }
    }

    func updateActivePet(petId: Int, completion: @escaping (Bool) -> Void) {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 존재하지 않음")
            completion(false)
            return
        }

        PetService.UpdateActivePet(petId: petId, token: token) { result in
            switch result {
            case .success(let response):
                print("대표 펫 변경 응답: \(response.message)")
                completion(true)
            case .failure(let error):
                print("대표 펫 변경 실패: \(error)")
                completion(false)
            }
        }
    }
}
