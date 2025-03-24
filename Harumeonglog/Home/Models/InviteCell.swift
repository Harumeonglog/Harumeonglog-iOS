//
//  InviteCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/14/25.
//

import UIKit
import SnapKit


class InviteCell: UITableViewCell {
    

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .gray00
        return label
    }()

    lazy var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue01
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .body
        return button
    }()

    lazy var declineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .body
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(acceptButton)
        contentView.addSubview(declineButton)

        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }

        declineButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(25)
        }

        acceptButton.snp.makeConstraints { make in
            make.trailing.equalTo(declineButton.snp.leading).offset(-9)
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(25)
        }
    }

    func configure(profileImage: String, nickname: String) {
        profileImageView.image = UIImage(named: profileImage) // ✅ 이미지 설정
        nicknameLabel.text = nickname
    }
    
}
