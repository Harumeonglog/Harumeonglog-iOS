//
//  InviteUserViewModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/22/25.
//

import Foundation
import Combine
import UIKit
import Alamofire

class InviteMemberViewModel: ObservableObject {
    
    @Published var stage: [Member] = []
    @Published var searched: [Member] = []
    @Published var isSearching: Bool = false
    @Published var isLoading: Bool = false
    @Published var isKeyboardVisible: Bool = false
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupKeyboardNotifications()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in
                self?.isKeyboardVisible = true
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.isKeyboardVisible = false
            }
            .store(in: &cancellables)
    }
    
    func search(_ text: String) {
        isLoading = true
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else {
            print("NO Access Token")
            return
        }
        InviteMemberService.searchUsers(keyword: text, cursor: 0, token: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.searched = response.result?.members ?? []
                case .failure(let error):
                    print("Search error:", error.localizedDescription)
                }
            }
        }
    }
    
    
    func inviteUsers(petID: Int) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else {
            print("NO Access Token")
            return
        }
        isLoading = true
        InviteMemberService.inviteUser(petID: petID, users: stage, token: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    print("Invite success:", response.result ?? "")
                case .failure(let error):
                    print("Invite failed:", error.localizedDescription)
                }
            }
        }
    }
    
    func update(member: Member) {
        if let index = stage.firstIndex(where: { $0.memberId == member.memberId }) {
            // 이미 stage에 있으면 제거
            stage[index] = member
        } else {
            // 없으면 추가
            stage.append(member)
        }
    }
    
}
