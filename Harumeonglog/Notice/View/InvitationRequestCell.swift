//
//  InvitationCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import UIKit
import Kingfisher

protocol InviteRequestCellDelegate: AnyObject {
    func didTapConfirmButton(of request: InvitationRequest)
    func didTapDeleteButton(of request: InvitationRequest)
}

class InvitationRequestCell: UICollectionViewCell {
    
    static let identifier = "InvitationRequestCollectionViewCell"
    private var request: InvitationRequest?
    private var delegate: InviteRequestCellDelegate?
    
    private lazy var profileImage = UIImageView().then {
        $0.image = UIImage(named: "defaultImage")
        $0.backgroundColor = .gray03
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.textColor = .black
    }
    
    public lazy var confirmButton = UIButton().then {
        $0.backgroundColor = .blue01
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    public lazy var deleteButton = UIButton().then {
        $0.backgroundColor = .background
        $0.layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.logout, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    public func configure(_ data: InvitationRequest, delegate: InviteRequestCellDelegate) {
        self.request = data
        nameLabel.text = data.petName
        profileImage.kf.setImage(with: URL(string: data.image), placeholder: UIImage(named: "defaultImage"))
        self.delegate = delegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    private func setConstraints() {
        self.addSubview(profileImage)
        self.addSubview(nameLabel)
        self.addSubview(confirmButton)
        self.addSubview(deleteButton)
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(25)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.trailing.equalTo(deleteButton.snp.leading).offset(-9)
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func didTapConfirmButton() {
        delegate?.didTapConfirmButton(of: self.request!)
    }
    
    @objc
    func didTapDeleteButton() {
        delegate?.didTapDeleteButton(of: self.request!)
    }
    
}


    

import SwiftUI
#Preview {
    InvitationRequestsViewController()
}
