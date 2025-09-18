//
//  ProfileSelectCollectionViewCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/2/25.
//

import UIKit
import SDWebImage

class ProfileSelectCollectionViewCell: UICollectionViewCell {
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .gray00
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail 
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .blue01
        imageView.isHidden = true
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.blue01.cgColor
        view.isHidden = true
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
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().inset(2)
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(profileImageView)
            make.width.height.equalTo(40)
        }
    }
    
    func configure(with profile: Profile, isSelected: Bool) {
        profileNameLabel.text = profile.name
        updateSelectionStyle(isSelected: isSelected)
        
        print("이미지 로딩 시도: \(profile.imageName)")
        
        // 기본 이미지 설정 - Settings와 동일한 defaultImage 사용
        let placeholderImage = UIImage(named: "defaultImage")
        profileImageView.image = placeholderImage
        
        // URL 유효성 검사 및 이미지 다운로드 (SDWebImage 캐시 사용)
        if !profile.imageName.isEmpty && profile.imageName != "string" && profile.imageName != "null",
           let url = URL(string: profile.imageName) {
            print("URL 생성 성공: \(url)")
            profileImageView.sd_setImage(with: url, placeholderImage: placeholderImage, options: [.retryFailed, .continueInBackground, .scaleDownLargeImages])
        } else {
            print("이미지 URL이 비어있거나 유효하지 않음: \(profile.imageName)")
        }
    }

    
    private func updateSelectionStyle(isSelected: Bool) {
        print("ProfileSelectCollectionViewCell - updateSelectionStyle: \(isSelected)")
        if isSelected {
            overlayView.isHidden = false
            checkmarkImageView.isHidden = false
            print("체크마크와 오버레이 표시됨")
        } else {
            overlayView.isHidden = true
            checkmarkImageView.isHidden = true
            print("체크마크와 오버레이 숨겨짐")
        }
    }
}
