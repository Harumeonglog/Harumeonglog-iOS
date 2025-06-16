//
//  PuppyTypeButton.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/18/25.
//

import UIKit

class DogSizeButton: UIButton {
    
    public var size: DogSizeEnum?
    
    // 기존 init 유지
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // 새 init 추가
    convenience init(_ size: DogSizeEnum) {
        self.init(frame: .zero)
        configure(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(size: DogSizeEnum) {
        self.size = size
        setUnselectedImage()
    }
    
    public func setSelectedImage() {
        guard let size = size else { return }
        self.setImage(size.selectedImage(), for: .normal)
    }
    
    public func setUnselectedImage() {
        guard let size = size else { return }
        self.setImage(size.unselectedImage(), for: .normal)
    }
}
