//
//  HomeViewController+Profile.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
// 프로필 선택 관련 로직


import UIKit

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
                    DispatchQueue.main.async {
                        self.homeView.nicknameLabel.text = profile.name
                        
                        // GUEST 역할인 경우 이벤트 추가 버튼 숨김
                        let role = selectedPet.role ?? "OWNER"  // 기본값 OWNER
                        if role == "GUEST" {
                            self.homeView.addeventButton.isHidden = true
                            print("프로필 변경: GUEST 역할이므로 이벤트 추가 버튼 숨김")
                        } else {
                            self.homeView.addeventButton.isHidden = false
                            print("프로필 변경: \(role) 역할이므로 이벤트 추가 버튼 표시")
                        }
                        
                        if let url = URL(string: profile.imageName) {
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                if let data = data, let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self.homeView.profileButton.setImage(image, for: .normal)
                                    }
                                }
                            }.resume()
                        }

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
            }
        }
    }
    @objc func profileImageTapped() {
        let profileModalVC = ProfileSelectModalViewController()
        profileModalVC.modalPresentationStyle = .pageSheet
        profileModalVC.delegate = self
        self.present(profileModalVC, animated: true)
    }
}
