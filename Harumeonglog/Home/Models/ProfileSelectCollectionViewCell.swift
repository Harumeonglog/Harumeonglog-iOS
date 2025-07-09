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
        imageView.contentMode = .scaleAspectFill
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
            make.centerX.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(-3)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(3)
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with profile: Profile, isSelected: Bool) {
        profileNameLabel.text = profile.name
        updateSelectionStyle(isSelected: isSelected)
        
        print("이미지 로딩 시도: \(profile.imageName)")
        
        // 기본 이미지를 비트맵으로 생성해서 사이즈 통일
        let placeholderImage = createPlaceholderImage()
        profileImageView.image = placeholderImage
        
        // URL에서 이미지 다운로드
        if let url = URL(string: profile.imageName), !profile.imageName.isEmpty {
            print("URL 생성 성공: \(url)")
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print("이미지 다운로드 실패: \(error)")
                    return
                }

    // 이미지 리사이즈 함수 추가
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                        print("이미지 로딩 성공")
                    }
                } else {
                    print("이미지 데이터 변환 실패")
                }
            }.resume()
        } else {
            print("URL 생성 실패 또는 빈 문자열: \(profile.imageName)")
        }
    }

    // 플레이스홀더 이미지 생성 함수 추가
    private func createPlaceholderImage() -> UIImage? {
        let size = CGSize(width: 70, height: 70)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // 배경 색상
            UIColor.systemGray5.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // 흰색으로 tint된 심볼 이미지 그리기
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
            if let symbolImage = UIImage(systemName: "pawprint.fill", withConfiguration: config)?
                .withTintColor(.white, renderingMode: .alwaysOriginal) {
                
                let symbolRect = CGRect(
                    x: (size.width - 30) / 2,
                    y: (size.height - 30) / 2,
                    width: 30,
                    height: 30
                )
                symbolImage.draw(in: symbolRect)
            }
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
