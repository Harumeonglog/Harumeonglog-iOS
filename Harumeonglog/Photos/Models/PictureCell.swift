//
//  PictureCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/19/25.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.isHidden = true
        return view
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 33, weight: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .brown02
        button.layer.cornerRadius = 8
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(addButton)

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }

        overlayView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }

        addButton.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setAddButtonEnabled(_ isEnabled: Bool) {
        addButton.isUserInteractionEnabled = isEnabled
        addButton.alpha = isEnabled ? 1.0 : 0.5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isAddButton: Bool, image: UIImage? = nil) {
        if isAddButton {
            imageView.isHidden = true
            overlayView.isHidden = true
            addButton.isHidden = false
        } else {
            imageView.image = image
            imageView.isHidden = false
            overlayView.isHidden = true
            addButton.isHidden = true
        }
    }

    func setSelectedBorder(_ isSelected: Bool) {
        if isSelected {
            self.layer.borderWidth = 3
            self.layer.borderColor = UIColor.blue01.cgColor
            overlayView.isHidden = false
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
            overlayView.isHidden = true
        }
    }
}
