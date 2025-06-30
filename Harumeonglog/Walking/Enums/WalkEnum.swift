//
//  WalkEnum.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/27/25.
//

import Foundation

enum WalkState {
    case notStarted
    case walking
    case paused
}


enum SelectedAllItems {
    case pet(WalkPets)
    case member(WalkMembers)
}
