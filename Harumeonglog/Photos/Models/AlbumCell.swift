//
//  AlbumCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//
import UIKit
import SnapKit
import SDWebImage

class AlbumCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.masksToBounds = true
        return imgView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray00
        label.font = .body
        return label
    }()

    let photosCountLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray02
        label.font = .description
        return label
    }()

    var album: Album?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addComponents() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(photosCountLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().offset(110)
            make.height.equalTo(23)
        }
        
        photosCountLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(0)
            make.leading.equalTo(nameLabel.snp.leading)
            make.height.equalTo(17)
        }
    }
    
    func configure(with album: Album) {
            self.album = album
            nameLabel.text = album.name
            
            // 사진 개수 표시
            photosCountLabel.text = "\(album.photosCount)장"
            photosCountLabel.textColor = .gray02

            // 이미지 로딩 - 강아지 이미지가 없으면 pawprint 표시
            if let urlString = album.mainImage, !urlString.isEmpty, urlString != "string", urlString != "null", let url = URL(string: urlString) {
                // SDWebImage 사용 시
                imageView.sd_setImage(with: url, placeholderImage: createDefaultProfileImage())
            } else {
                imageView.image = createDefaultProfileImage()
            }
        }
    
    // 기본 프로필 이미지 생성 함수 (홈화면과 동일한 스타일의 pawprint.fill)
    private func createDefaultProfileImage() -> UIImage? {
        let size = CGSize(width: 90, height: 90)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // 배경 색상 - 홈화면과 동일하게 systemGray5
            UIColor.systemGray5.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // 흰색으로 tint된 pawprint.fill 심볼 이미지 그리기
            let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
            if let symbolImage = UIImage(systemName: "pawprint.fill", withConfiguration: config)?
                .withTintColor(.white, renderingMode: .alwaysOriginal) {
                
                let symbolRect = CGRect(
                    x: (size.width - 50) / 2,
                    y: (size.height - 50) / 2,
                    width: 50,
                    height: 50
                )
                symbolImage.draw(in: symbolRect)
            }
        }
    }
}

extension UIView {
    func viewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if nextResponder is UIViewController {
                return nextResponder as? UIViewController
            }
            responder = nextResponder
        }
        return nil
    }
}

struct Album {
    let mainImage: String?
    let name: String
    var photosCount: Int
    let petId: Int
    
    //서버에서 받아온 이미지 메타데이터
    var imageInfos: [PetImage]
    //메모리에 로드된 실제 이미지들
    var uiImages:[UIImage]
}
