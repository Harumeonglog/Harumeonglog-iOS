//
//  UserStageModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/7/25.
//

import UIKit

struct UserStageData {
    let username: String
    let userProfile: UIImage = .dog1
    var userLevel: UserLevelEnum
}

class UserStageModel {
    static var data: [UserStageData] = [
        UserStageData(username: "Harry", userLevel: .guest),
        UserStageData(username: "Gale", userLevel: .owner),
        UserStageData(username: "Jones", userLevel: .owner),
    ]
}
