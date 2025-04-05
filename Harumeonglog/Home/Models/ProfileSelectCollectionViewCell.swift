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
        label.font = .headline
        label.textColor = .gray00
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        addSubview(profileImageView)
        addSubview(profileNameLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func configure(with profile: Profile) {
        profileImageView.image = UIImage(named: profile.imageName)
        profileNameLabel.text = profile.name
    }
}
