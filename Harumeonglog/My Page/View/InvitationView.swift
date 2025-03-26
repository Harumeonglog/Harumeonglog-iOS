//
//  InvitationView.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/19/25.
//

import UIKit

class InvitationView: UIView {
    
    private let leadingTrailingPadding: CGFloat = 22
    
    public lazy var navigationBar = CustomNavigationBar()
    
    public lazy var invitationMessageCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 44, height: 50)
        layout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .background
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.bouncesHorizontally = false
        
        cv.register(InvitationCollectionViewCell.self,
                    forCellWithReuseIdentifier: InvitationCollectionViewCell.identifier)
        return cv
    }()
    
    public func setConstraints() {
        self.backgroundColor = .background
        setNavigationBarConstraints()
        setCollectionViewConstraints()
    }
    
    private func setNavigationBarConstraints() {
        self.addSubview(navigationBar)
        navigationBar.configureTitle(title: "초대 요청")
        
        self.navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setCollectionViewConstraints() {
        self.addSubview(invitationMessageCollectionView)
        
        invitationMessageCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(22)
            make.top.equalTo(navigationBar.snp.bottom).offset(35)
            make.bottom.equalToSuperview()
        }
    }
    
}
