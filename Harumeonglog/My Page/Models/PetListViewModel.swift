//
//  PetListViewModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/16/25.
//

import Combine
import Foundation

class PetListViewModel: ObservableObject {
    
    @Published var petList: [Pet] = []
    @Published var isFetching: Bool = false
    var cursor: Int = 0
    var hasNext: Bool = true
    var cancellables: Set<AnyCancellable> = []
    
    func getPetList(completion: @escaping (HaruResponse<PetListResponse>?) -> Void) {
        guard !isFetching else { print("반려동물 리스트 조회 isFetching true"); return }
        guard hasNext else { print("반려동물 리스트 조회 hasNext false"); return }
        self.isFetching = true
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            completion(nil)
            return
        }
        PetService.getPets(cursor: cursor, token: token) { result in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    if let result = response.result {
                        DispatchQueue.main.async {
                            print("pet list : ", result.pets ?? [])
                            self.petList.append(contentsOf: result.pets ?? [])
                            self.cursor = result.cursor ?? 0
                            self.hasNext = result.hasNext
                        }
                    } else {
                        print("반려동물 리스트 조회 Empty Result")
                    }
                } else {
                    print("반려동물 리스트 조회 예외 코드 \(response.code), message: \(response.message)")
                }
            case .failure(let error):
                print("반려동물 리스트 조회 에러: \(error)")
                completion(nil)
            }
            self.isFetching = false
        }
    }
    
    func postPet(newInfo: PetParameter, completion: @escaping (HaruResponse<PetPostResponse>?) -> Void) {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            completion(nil)
            return
        }
        PetService.postPet(newInfo: newInfo, token: token) { result in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("반려동물 추가 상공")
                    self.petList = []
                    self.hasNext = true
                    self.getPetList{_ in}
                } else {
                    print("반려동물 추가 예외 코드: \(response.code), message: \(response.message)")
                }
            case .failure(let error):
                print("반려동물 추가 에러: \(error)")
                completion(nil)
            }
        }
    }
    
    func patchPet(petId: Int, newInfo: PetParameter, completion: @escaping (HaruResponse<PetPatchResponse>?) -> Void) {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            completion(nil)
            return
        }
        PetService.patchPet(petId: petId, token: token, newInfo: newInfo) { result in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("반려동물 수정 상공")
                    self.petList = []
                    self.hasNext = true
                    self.getPetList{_ in}
                } else {
                    print("반려동물 수정 예외 코드: \(response.code), message: \(response.message)")
                }
            case .failure(let error):
                print("반려동물 수정 에러: \(error)")
                completion(nil)
            }
        }
    }
    
    func deletePet(petId: Int, completion: @escaping (HaruResponse<String>?) -> Void) {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            completion(nil)
            return
        }
        PetService.deletePet(petId: petId, token: token) { result in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("반려동물 삭제 상공")
                    self.petList.removeAll { $0.petId == petId }
                } else {
                    print("반려동물 삭제 예외 코드: \(response.code), message: \(response.message)")
                }
            case .failure(let error):
                print("반려동물 삭제 에러: \(error)")
                completion(nil)
            }
        }
    }
    
}
