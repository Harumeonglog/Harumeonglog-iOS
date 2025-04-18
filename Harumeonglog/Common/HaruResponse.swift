//
//  APIResponse.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/18/25.
//

import Foundation

struct HaruResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
}
