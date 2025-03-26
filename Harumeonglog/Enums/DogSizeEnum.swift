//
//  DogSizeEnum.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/25/25.
//

import UIKit

enum DogSizeEnum {
    case small, middle, big
    
    func unselectedImage() -> UIImage {
        switch self {
        case .small:
            return .smallDogButton
        case .middle:
            return .middleDogButton
        case .big:
            return .bigDogButton
        }
    }
    
    func selectedImage() -> UIImage {
        switch self {
        case .small:
            return .smallDogButtonSelected
        case .middle:
            return .middleDogButtonSelected
        case .big:
            return .bigDogButtonSelected
        }
    }
    
    func inKorean() -> String {
        switch self {
        case .small:
            return "소형견"
        case .middle:
            return "중형견"
        case .big:
            return "대형견"
        }
    }
}
