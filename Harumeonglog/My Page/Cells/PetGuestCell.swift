//
//  PetCollectionViewCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/26/25.
//

import UIKit

protocol PetGuestCellDelegate: AnyObject {
    func didTapExitButton(petId: Int)
}

class PetGuestCell: UICollectionViewCell {
    
    static let identifier = "PetGuestCell"
    var delegate: PetGuestCellDelegate?
    var pet: PetDTO?
    // Owner, Guest 공통 부분
    private lazy var profileImage = UIImageView().then {
        $0.image = UIImage(named: "defaultImage")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray02
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.body
        $0.textColor = .black
    }
    
    private lazy var genderLabel = commonLabel()
    private lazy var divider = UIView().then {
        $0.backgroundColor = .gray01
    }
    
    private lazy var dogSizeLabel = commonLabel()
    private lazy var birthdayLabel = commonLabel()
    
    private lazy var accessLevelTagImageView = UIImageView().then {
        $0.image = .guestTag
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    public lazy var exitButton = UIButton().then {
        $0.setImage(.exit, for: .normal)
    }
    
    public func configure(_ pet: PetDTO, delegate: PetGuestCellDelegate) {
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        self.pet = pet
        self.delegate = delegate
        setDefaultConstraints()
        profileImage.kf.setImage(with: URL(string: pet.mainImage ?? ""), placeholder: UIImage(named: "defaultImage"))
        nameLabel.text = pet.name
        genderLabel.text = pet.gender
        dogSizeLabel.text = pet.size
        birthdayLabel.text = "🎂 " + (pet.birth ?? "")
    }
    
    private func setDefaultConstraints() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.addSubview(profileImage)
        self.addSubview(nameLabel)
        self.addSubview(genderLabel)
        self.addSubview(divider)
        self.addSubview(dogSizeLabel)
        self.addSubview(birthdayLabel)
        self.addSubview(accessLevelTagImageView)
        self.addSubview(exitButton)
        
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.leading.top.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.top.equalTo(profileImage.snp.top).offset(10)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.centerY.equalTo(profileImage.snp.centerY)
        }
        
        divider.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.leading.equalTo(genderLabel.snp.trailing).offset(7)
            make.centerY.equalTo(genderLabel)
            make.height.equalTo(15)
        }
        
        dogSizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderLabel.snp.trailing).offset(16)
            make.centerY.equalTo(genderLabel)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderLabel)
            make.top.equalTo(dogSizeLabel.snp.bottom).offset(7)
        }
        
        exitButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.top.equalTo(profileImage.snp.top).inset(-10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        accessLevelTagImageView.snp.makeConstraints { make in
            make.centerY.equalTo(exitButton)
            make.trailing.equalTo(exitButton.snp.leading)
            make.height.equalTo(25)
            make.width.equalTo(70)
        }
    }
    
    @objc
    private func exitButtonTapped() {
        guard let pet = pet else { print("cell 안의 pet이 비어있습니다."); return }
        guard let petId = pet.petId else { print("pet의 id가 비어있습니다."); return }
        delegate?.didTapExitButton(petId: petId)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonLabel() -> UILabel {
        return UILabel().then {
            $0.textColor = .gray01
            $0.font = UIFont.body
        }
    }
    
}

import SwiftUI
#Preview {
    PetListViewController()
}
