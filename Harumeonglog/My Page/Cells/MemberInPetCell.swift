//
//  MemberInPetCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/19/25.
//

import UIKit

protocol MemberInPetCellDelegate: AnyObject {
    func didTapEditMemberButton(for member: PetMember, at indexPath: IndexPath)
    func didTapDeleteMember(member: PetMember, petId: Int)
}

class MemberInPetCell: UITableViewCell {
    
    static let identifier: String = "MemberInPetCell"
        
    private var member: PetMember?
    private var indexPath: IndexPath?
    private weak var delegate: MemberInPetCellDelegate?
    
    private lazy var userProfileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
    
    public lazy var editButton = UIButton().then {
        $0.setImage(.meatballsMenu, for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    func configure(with member: PetMember, at indexPath: IndexPath, delegate: MemberInPetCellDelegate?) {
        self.member = member
        self.indexPath = indexPath
        self.delegate = delegate
        self.selectionStyle = .none
        
        userProfileImage.kf.setImage(with: URL(string: member.image))
        nameLabel.text = member.name
        roleLabel.text = member.role
        
        setupEditButton()
        constraints()
    }
    
    private func setupEditButton() {
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
    }
    
    @objc private func didTapEditButton() {
        guard let member = member, let indexPath = indexPath else { return }
        delegate?.didTapEditMemberButton(for: member, at: indexPath)
    }
    
    func constraints() {
        self.backgroundColor = .brown02
        self.addSubview(userProfileImage)
        self.addSubview(nameLabel)
        self.addSubview(roleLabel)
        self.addSubview(editButton)
        
        userProfileImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(userProfileImage.snp.trailing).offset(11)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(20)
        }
        
        roleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(editButton.snp.leading).offset(-12)
        }
        
    }
}

