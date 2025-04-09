//
//  ImageCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/28/25.
//

import UIKit
import SnapKit
import Then

class AddImageViewCell: UICollectionViewCell {
    
    static let identifier = "AddImageViewCell"
    
    public lazy var imageView = UIImageView().then { imageView in
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    public lazy var deleteButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
        }
    }
}
