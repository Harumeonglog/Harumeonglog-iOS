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
}
