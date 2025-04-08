//
//  UserLevelToggleButton.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/7/25.
//

import UIKit

class UserLevelToggleButton: UIButton {
    
    private var userLevel: UserLevelEnum = .guest
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(.guestSelected, for: .normal)
        self.contentMode = .scaleAspectFit
    }
    
    public func setUserLevel(_ userLevel: UserLevelEnum) {
        switch userLevel {
        case .guest:
            self.setImage(.guestSelected, for: .normal)
        case .owner:
            self.setImage(.ownerSelected, for: .normal)
        }
        self.userLevel = userLevel
    }
    
    public func toggleUserLevel() -> UserLevelEnum {
        switch userLevel {
        case .guest:
            self.setImage(.ownerSelected, for: .normal)
            userLevel = .owner
        case .owner:
            self.setImage(.guestSelected, for: .normal)
            userLevel = .guest
        }
        return userLevel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
