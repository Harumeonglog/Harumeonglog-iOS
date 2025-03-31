//
//  PetListView.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/26/25.
//

import UIKit

class PetListView: UIView {
    
    public lazy var navigationBar = CustomNavigationBar()
    
    public lazy var petListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 23
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .background
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.bouncesHorizontally = false
        
        cv.register(PetGuestCell.self,
                    forCellWithReuseIdentifier: PetGuestCell.identifier)
        cv.register(PetOwnerCell.self,
                    forCellWithReuseIdentifier: PetOwnerCell.identifier)
        return cv
    }()
    
    public lazy var addPetButton = ConfirmButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setConstraints() {
        self.addSubview(navigationBar)
        self.addSubview(petListCollectionView)
        self.addSubview(addPetButton)
        
        navigationBar.configureTitle(title: "반려견 목록")
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.safeAreaLayoutGuide)
        }
        
        petListCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(navigationBar.snp.bottom).offset(26)
            make.bottom.equalToSuperview().inset(120)
        }
        
        addPetButton.configure(labelText: "반려견 추가")
        addPetButton.addPlusImage()
        addPetButton.available()
        
        addPetButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}

import SwiftUI
#Preview {
    PetListViewController()
}
