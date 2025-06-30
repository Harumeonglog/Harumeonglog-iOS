//
//  ProfileSelectCollectionViewCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/2/25.
//

import UIKit

class ProfileSelectCollectionViewCell: UICollectionViewCell {
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .gray00
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        imageView.tintColor = .blue01
        imageView.isHidden = true
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.blue01.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        updateSelectionStyle(isSelected: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        addSubview(profileImageView)
        addSubview(profileNameLabel)
        addSubview(checkmarkImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        profileImageView.addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(-5)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(5)
            make.width.height.equalTo(20)
        }
    }
    
    func configure(with profile: Profile, isSelected: Bool) {
        profileImageView.image = UIImage(named: profile.imageName)
        profileNameLabel.text = profile.name
        updateSelectionStyle(isSelected: isSelected)
    }
    
    private func updateSelectionStyle(isSelected: Bool) {
        if isSelected {
            overlayView.isHidden = false
            checkmarkImageView.isHidden = false
        } else {
            overlayView.isHidden = true
            checkmarkImageView.isHidden = true
        }
    }
}
