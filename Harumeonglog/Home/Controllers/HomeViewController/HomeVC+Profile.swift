//
//  HomeViewController+Profile.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
// 프로필 선택 관련 로직


import UIKit
import Foundation

extension HomeViewController: ProfileSelectDelegate {
    
    func didSelectProfile(_ profile: Profile) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken), !accessToken.isEmpty else {
            print("AccessToken이 존재하지 않음")
            return
        }

        petViewModel.updateActivePet(petId: profile.petId) { success in
            guard success else {
                print("대표 펫 변경 실패")
                return
            }

            print("대표 펫 변경 성공")
            
            // 프로필 변경 후 활성 펫 정보 다시 조회하여 버튼 상태 업데이트
            self.petViewModel.fetchActivePets { activePetsResult in
                guard let activePets = activePetsResult else { return }
                
                if let selectedPet = activePets.pets.first(where: { $0.petId == profile.petId }) {
                    // 새로운 활성 펫의 상세 정보 가져오기 (생일 정보 포함)
                    PetService.ActivePetInfo(token: accessToken) { result in
                        switch result {
                        case .success(let response):
                            if let activePetInfo = response.result {
                                DispatchQueue.main.async {
                                    self.homeView.nicknameLabel.text = activePetInfo.name
                                    
                                    // 생일 정보 업데이트
                                    self.homeView.birthdayLabel.text = activePetInfo.birth
                                    // 성별 아이콘 업데이트
                                    self.updateGenderIcon(activePetInfo.gender)
                                    
                                    // GUEST 역할인 경우 이벤트 추가 버튼 숨김
                                    let role = selectedPet.role ?? "OWNER"  // 기본값 OWNER
                                    if role == "GUEST" {
                                        self.homeView.addeventButton.isHidden = true
                                        print("프로필 변경: GUEST 역할이므로 이벤트 추가 버튼 숨김")
                                    } else {
                                        self.homeView.addeventButton.isHidden = false
                                        print("프로필 변경: \(role) 역할이므로 이벤트 추가 버튼 표시")
                                    }
                                    
                                    // 이미지 로딩 개선
                                    self.loadProfileImage(activePetInfo.mainImage ?? "")

                                    // ✅ 이벤트 날짜 업데이트 → reloadData 내부에서 처리되게 보장
                                    self.fetchEventDatesForCurrentMonth {
                                        // 선택된 날짜 일정 다시 불러오기
                                        if let selectedDate = self.homeView.calendarView.selectedDate {
                                            self.eventViewModel.fetchEventsByDate(selectedDate, token: accessToken) { result in
                                                switch result {
                                                case .success(let events):
                                                    DispatchQueue.main.async {
                                                        let mappedEvents = events.map { Event(id: $0.id, title: $0.title, category: CategoryType.other.serverKey, done: $0.done) }
                                                        self.homeView.eventView.updateEvents(mappedEvents)
                                                    }
                                                case .failure(let error):
                                                    print("대표펫 변경 후 날짜 일정 불러오기 실패: \(error)")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        case .failure(let error):
                            print("프로필 변경 후 ActivePetInfo 조회 실패: \(error)")
                            // 실패 시 기본 정보로 업데이트
                            DispatchQueue.main.async {
                                self.homeView.nicknameLabel.text = profile.name
                                self.loadProfileImage(profile.imageName)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    // 프로필 이미지 로딩 메서드
    private func loadProfileImage(_ imageName: String) {
        // 기본 이미지 설정 - Settings와 동일한 defaultImage 사용
        let defaultImage = UIImage(named: "defaultImage")
        homeView.profileButton.setImage(defaultImage, for: .normal)
        
        // 유효한 이미지 URL인 경우에만 로딩 시도
        if !imageName.isEmpty && imageName != "string" && imageName != "null" {
            if let url = URL(string: imageName) {
                print("프로필 이미지 로딩 시도: \(url)")
                
                // 이미지 캐싱을 위한 URLSession 설정
                let config = URLSessionConfiguration.default
                config.requestCachePolicy = .returnCacheDataElseLoad
                config.urlCache = URLCache.shared
                config.timeoutIntervalForRequest = 10 // 10초 타임아웃
                
                let session = URLSession(configuration: config)
                session.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print("프로필 이미지 다운로드 실패: \(error)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("프로필 이미지 HTTP 응답: \(httpResponse.statusCode)")
                        if httpResponse.statusCode != 200 {
                            print("프로필 이미지 HTTP 오류: \(httpResponse.statusCode)")
                            return
                        }
                    }
                    
                    if let data = data, !data.isEmpty, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.homeView.profileButton.setImage(image, for: .normal)
                            print("프로필 이미지 로딩 성공 - 크기: \(data.count) bytes")
                        }
                    } else {
                        print("프로필 이미지 데이터 변환 실패 - 데이터 크기: \(data?.count ?? 0)")
                        // 실패 시 기본 이미지 유지
                    }
                }.resume()
            } else {
                print("프로필 이미지 URL이 유효하지 않음: \(imageName)")
                // 유효하지 않은 URL 시 기본 이미지 유지
            }
        } else {
            print("프로필 이미지 URL이 비어있거나 유효하지 않음: \(imageName)")
            // 빈 URL 시 기본 이미지 유지
        }
    }
    
    @objc func profileImageTapped() {
        // Prevent duplicate presentation
        if self.presentedViewController is ProfileSelectModalViewController { return }
        let profileModalVC = ProfileSelectModalViewController()
        profileModalVC.modalPresentationStyle = .pageSheet
        profileModalVC.delegate = self
        self.present(profileModalVC, animated: true)
    }
}
