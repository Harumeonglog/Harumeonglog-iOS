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
    
    // Optional: name text field with length limit to prevent overflow
    let nameTextField: LimitedLengthTextField = {
        let tf = LimitedLengthTextField()
        tf.maxLength = 12
        tf.font = .body
        tf.textColor = .gray00
        tf.textAlignment = .center
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.brown02.cgColor
        tf.layer.cornerRadius = 12
        tf.isHidden = true // shown if needed
        return tf
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 50 //옆 간격
        layout.minimumLineSpacing = 40 //위아래 간격
        layout.itemSize = CGSize(width: 70, height: 110) //cell size
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
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
        addSubview(nameTextField)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
    }
}
