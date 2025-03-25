//
//  PuppyTypeButton.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/18/25.
//

import UIKit

class DogSizeButton: UIButton {
    
    public var size: DogSizeEnum?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(size: DogSizeEnum) {
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
    
}
