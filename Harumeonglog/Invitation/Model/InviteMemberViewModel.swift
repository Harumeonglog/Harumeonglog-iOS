//
//  InviteUserViewModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/22/25.
//

import Foundation
import Combine
import UIKit

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
    
    
    
}
