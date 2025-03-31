//
//  PhotoAlbumsView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//
import UIKit
import SnapKit

class PhotoAlbumsView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bg
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // album 예시
    var albums: [Album] = [
        Album(coverImage: UIImage(named: "doggo")!,
              images: [UIImage(named: "doggo")!, UIImage(named: "doggo")!, UIImage(named: "doggo")!, UIImage(named: "doggo")!,UIImage(named: "doggo")!,UIImage(named: "doggo")!],
              name: "누룽지",
              photosCount: 308),
        Album(coverImage: UIImage(named: "doggo")!,
              images: [UIImage(named: "doggo")!, UIImage(named: "doggo")!],
              name: "호빵이",
              photosCount: 10),
        Album(coverImage: UIImage(named: "doggo")!,
              images: [UIImage(named: "doggo")!, UIImage(named: "doggo")!, UIImage(named: "doggo")!],
              name: "바보",
              photosCount: 503),
        Album(coverImage: UIImage(named: "doggo")!,
              images: [UIImage(named: "doggo")!],
              name: "나비",
              photosCount: 283)
    ]
    

    
    lazy var albumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 362, height: 90)
        layout.minimumLineSpacing = 13
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .bg
        return collectionView
    }()
    
    private func addComponents(){
        self.addSubview(albumCollectionView)
        
        albumCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(142)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(0)
        }
    }
   
}

