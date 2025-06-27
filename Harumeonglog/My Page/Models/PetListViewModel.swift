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
    
    private var currentUserId: Int? {
        return MemberAPIService.userInfo?.memberId
    }
    
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
                            // 본인을 제외한 멤버 리스트로 필터링
                            _ = result.pets?.map { pet in
                                var filteredPet = pet
                                filteredPet.people = self.filterOutCurrentUser(from: pet.people)
                                return filteredPet
                            }
                            
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
    
    // 현재 사용자를 제외하는 필터링 함수
    private func filterOutCurrentUser(from members: [PetMember]?) -> [PetMember]? {
        guard let members = members, let currentUserId = currentUserId else {
            print("member 또는 currentUserId가 없습니다.")
            return members
        }
        
        return members.filter { member in
            member.id != currentUserId
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
                    self.refreshPetList()
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
                    self.refreshPetList()
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
    
    func deletePetMember(memberId: Int, petId: Int, completion: @escaping (Bool) -> Void) {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            completion(false)
            return
        }
        
        // API 호출 (실제 API 엔드포인트에 맞게 수정 필요)
        PetService.deletePetMember(memberId: memberId, petId: petId, token: token) { [weak self] result in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    DispatchQueue.main.async {
                        // 로컬 데이터 업데이트
                        if let petIndex = self?.petList.firstIndex(where: { $0.petId == petId }) {
                            self?.petList[petIndex].people?.removeAll { $0.id == memberId }
                        }
                        completion(true)
                    }
                } else {
                    print("멤버 삭제 실패: \(response.message)")
                    completion(false)
                }
            case .failure(let error):
                print("멤버 삭제 에러: \(error)")
                completion(false)
            }
        }
    }
    
    private func refreshPetList() {
        self.petList = []
        self.cursor = 0
        self.hasNext = true
        self.getPetList { _ in }
    }
    
}
