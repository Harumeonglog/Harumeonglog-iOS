//
//  PuppyTypeButton.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/18/25.
//

import UIKit

class PuppySizeButton: UIButton {
    
    private var size: dogSizeEnum?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(size: dogSizeEnum) {
        switch size {
        case .small:
            self.size = .small
        case .middle:
            self.size = .middle
        case .big:
            self.size = .big
        }
        setUnselectedImage()
    }
    
    public func setSelectedImage() {
        self.setImage(size!.selectedImage(), for: .normal)
    }
    
    public func setUnselectedImage() {
        self.setImage(size!.unselectedImage(), for: .normal)
    }
    
    enum dogSizeEnum {
        case small
        case middle
        case big
        
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
    
}
