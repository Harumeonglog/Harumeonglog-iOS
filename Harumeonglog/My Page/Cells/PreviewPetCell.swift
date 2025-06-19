//
//  PreviewPetCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/19/25.
//

import UIKit

class PreviewPetCell: UITableViewCell {
    
    static let identifier: String = "PreviewPetCell"
    private var pet: Pet?
    
    private lazy var petImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.body
        $0.textColor = .black
    }
    
    private lazy var roleLabel = UILabel().then {
        $0.font = UIFont.body
        $0.textColor = .gray
    }
    
    func configure(with pet: Pet) {
        self.pet = pet
        petImage.kf.setImage(with: URL(string: pet.mainImage ?? "")!)
        nameLabel.text = pet.name
        roleLabel.text = pet.role
        constraints()
    }
    
    func constraints() {
        self.addSubview(petImage)
        self.addSubview(nameLabel)
        self.addSubview(roleLabel)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        petImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(petImage.snp.trailing).offset(11)
        }
        
        roleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
    }
}
