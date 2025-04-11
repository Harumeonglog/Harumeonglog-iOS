//
//  PetOwnerCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/29/25.
//

import UIKit

protocol PetOwnerCellDelegate: AnyObject {
    func didTapInviteButton()
    func didTapExitButton()
    func didTapEditButton()
}

class PetOwnerCell: UICollectionViewCell {
    
    private weak var delegate: PetOwnerCellDelegate?
    static let identifier = "PetOwnerCell"
    
    private lazy var profileImage = UIImageView().then {
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
        $0.image = .ownerTag
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    public lazy var exitButton = UIButton().then {
        $0.setImage(.meatballsMenu , for: .normal)
    }
    
    public lazy var editPuppyInfoButton = UIButton().then {
        $0.setImage(.editPuppy, for: .normal)
    }
    
    public lazy var memberTableView = UITableView().then {
        $0.backgroundColor = .brown02
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    public lazy var sendInviationButton = UIButton().then {
        $0.setImage(.sendInvitation, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    public func configure(_ petData: PetData, delegate: PetOwnerCellDelegate?) {
        self.delegate = delegate
        setDefaultConstraints()
        profileImage.image = petData.image
        nameLabel.text = petData.name
        genderLabel.text = petData.gender
        dogSizeLabel.text = petData.size.inKorean()
        birthdayLabel.text = "🎂 " + petData.birthday
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
        self.addSubview(editPuppyInfoButton)
        self.addSubview(memberTableView)
        self.addSubview(sendInviationButton)
        
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.leading.top.equalToSuperview().offset(20)
        }
        
        editPuppyInfoButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.bottom.equalTo(profileImage)
        }
        editPuppyInfoButton.isHidden = true
        
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
        
        memberTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(profileImage.snp.bottom).offset(24)
            make.height.equalTo(157)
        }
        
        sendInviationButton.snp.makeConstraints { make in
            make.top.equalTo(memberTableView.snp.bottom).offset(11)
            make.trailing.equalToSuperview().inset(21)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        self.editPuppyInfoButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        self.sendInviationButton.addTarget(self, action: #selector(showInvitaionVC), for: .touchUpInside)
    }
    
    @objc
    private func showInvitaionVC() {
        delegate?.didTapInviteButton()
    }
    
    @objc
    private func didTapEditButton() {
        delegate?.didTapEditButton()
    }
    
    @objc
    private func didTapExitButton() {
        delegate?.didTapExitButton()
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
