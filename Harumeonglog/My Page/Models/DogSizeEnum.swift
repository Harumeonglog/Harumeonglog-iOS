//
//  DogSizeEnum.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/25/25.
//

import UIKit

enum DogSizeEnum: String, Codable {
    case SMALL, MEDIUM, BIG
    
    func unselectedImage() -> UIImage {
        switch self {
        case .SMALL:
            return .smallDogButton
        case .MEDIUM:
            return .middleDogButton
        case .BIG:
            return .bigDogButton
        }
    }
    
    func selectedImage() -> UIImage {
        switch self {
        case .SMALL:
            return .smallDogButtonSelected
        case .MEDIUM:
            return .middleDogButtonSelected
        case .BIG:
            return .bigDogButtonSelected
        }
    }
    
    func inKorean() -> String {
        switch self {
        case .SMALL:
            return "소형견"
        case .MEDIUM:
            return "중형견"
        case .BIG:
            return "대형견"
        }
    }
}
