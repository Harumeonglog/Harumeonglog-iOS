//
//  HomeViewController+Profile.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
// 프로필 선택 관련 로직


import UIKit

extension HomeViewController: ProfileSelectDelegate {
    
    // 프로필이 선택되었을 때 호출되는 메서드 - 생일, 이름 바뀌도록
    func didSelectProfile(_ profile: Profile) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken), !accessToken.isEmpty else {
            print("AccessToken이 존재하지 않음")
            return
        }

        // 대표 펫 변경 API 호출
        petViewModel.updateActivePet(petId: profile.petId) { success in
            if success {
                print("대표 펫 변경 성공")

                DispatchQueue.main.async {
                    self.homeView.nicknameLabel.text = profile.name

                    if let url = URL(string: profile.imageName) {
                        URLSession.shared.dataTask(with: url) { data, _, _ in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.homeView.profileButton.setImage(image, for: .normal)
                                }
                            }
                        }.resume()
                    }
                }
            } else {
                print("대표 펫 변경 실패")
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
