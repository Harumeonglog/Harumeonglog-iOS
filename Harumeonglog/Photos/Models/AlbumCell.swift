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
        contentView.layer.cornerRadius = 20
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
            photosCountLabel.text = "\(album.photosCount)"

            // 이미지 로딩
            if let urlString = album.mainImage, let url = URL(string: urlString) {
                // SDWebImage 사용 시
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imageView.image = UIImage(named: "placeholder")
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
    var images : [UIImage]
    let name: String
    let photosCount: Int
    let petId : Int
}
