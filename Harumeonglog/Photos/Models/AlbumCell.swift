//
//  AlbumCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//
import UIKit
import SnapKit

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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapGesture)
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

    @objc private func cellTapped() {
        if let album = album {
            if let parentVC = self.viewController(), let navigationController = parentVC.navigationController {
                let photosVC = PhotosViewController(album: album)
                navigationController.pushViewController(photosVC, animated: true)
            } else {
                print("Navigation controller not found")
            }
        }
    }
    
    func configure(with album: Album) {
        self.album = album
        imageView.image = album.coverImage
        nameLabel.text = album.name
        photosCountLabel.text = "\(album.photosCount)"
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
    let coverImage: UIImage
    var images : [UIImage]
    let name: String
    let photosCount: Int
}
