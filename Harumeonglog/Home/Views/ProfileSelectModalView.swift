//
//  ProfileSelectModalView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/2/25.
//

import UIKit
import SnapKit

class ProfileSelectModalView: UIView {
    
    var delegate: ProfileSelectDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 50 //옆 간격
        layout.minimumLineSpacing = 40 //위아래 간격
        layout.itemSize = CGSize(width: 70, height: 110) //cell size
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(ProfileSelectCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileCell")
        collectionView.showsVerticalScrollIndicator = false  // 수직 스크롤바 숨기기
        collectionView.showsHorizontalScrollIndicator = false  // 수평 스크롤바 숨기기
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addComponents()
        
        // 모달이 하단에서 올라오는 애니메이션
        self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(100) // 좌우 여백 설정
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
