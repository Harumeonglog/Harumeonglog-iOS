//
//  ChooseDogView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/30/25.
//

import UIKit
import SnapKit
import Then

class ChooseDogView: UIView {
    
    private lazy var titleLabel = UILabel().then { label in
        label.text = "누구와 함께하는 산책인가요 ?"
        label.textColor = .gray00
        label.textAlignment = .center
        label.font = .init(name: "Pretendard-Bold", size: 20)
    }
    
    public lazy var dogCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then { layout in
        
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 40
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
    }).then { collectionView in
        collectionView.register(ChooseProfileViewCell.self, forCellWithReuseIdentifier: "ChooseProfileViewCell")
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
    }
    
    public lazy var chooseSaveBtn = UIButton().then { button in
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 17)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .gray03
        button.layer.cornerRadius = 25
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(550)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(dogCollectionView)
        dogCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(280)
            make.width.equalTo(240)
        }
        
        self.addSubview(chooseSaveBtn)
        chooseSaveBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(130)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
}
