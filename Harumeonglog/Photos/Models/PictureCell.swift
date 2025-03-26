//
//  PictureCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/19/25.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    // Image view to display the image
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // Add button for adding a new image
    var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .brown02
        button.layer.cornerRadius = 10
        return button
    }()
    
    // Configure the cell based on whether it's the "add" button or image cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(addButton)
        
        // Add constraints using SnapKit or manually
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)  // Set the size of the add button
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isAddButton: Bool, image: UIImage? = nil) {
        if isAddButton {
            imageView.isHidden = true
            addButton.isHidden = false
        } else {
            imageView.image = image
            imageView.isHidden = false
            addButton.isHidden = true
        }
    }
}
