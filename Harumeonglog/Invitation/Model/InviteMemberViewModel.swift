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
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else {
            print("NO Access Token")
            return
        }
        InviteMemberService.searchUsers(keyword: text, cursor: 0, token: accessToken) { [weak self] result in
            switch result {
            case .success(let response):
                self?.searched = response.result?.members ?? []
            case .failure(let error):
                print("Search error:", error.localizedDescription)
            }
        }
    }
    
    func inviteUsers(petId: Int) {
        InviteMemberService.inviteUser(petID: petId, users: stage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.stage.removeAll()
                print("Invite success:", response.result ?? "")
            case .failure(let error):
                print("Invite failed:", error.localizedDescription)
            }
        }
    }
    
    func addToStage(_ member: Member) {
        if !stage.contains(where: { $0.memberId == member.memberId }) {
            stage.append((member))
            stage[stage.count - 1].level = .GUEST
        }
    }
    
    func update(member: Member) {
        if let index = stage.firstIndex(where: { $0.memberId == member.memberId }) {
            stage[index] = member
        } else {
            stage.append(member)
        }
    }
    
}
