//
//  InviteUser.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/6/25.
//

import UIKit

class InviteUserView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public lazy var navigationBar = CustomNavigationBar()
    
    public lazy var searchTextField = UITextField().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.font = UIFont.body
        
        $0.backgroundColor = .white
        $0.tintColor = .gray02
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.brown02.cgColor
        $0.placeholder = "사용자 검색"
    }
    
    public lazy var inviteButton = ConfirmButton()
    
    public lazy var userStageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .background
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.bouncesHorizontally = false
        
        cv.register(UserStageCell.self, forCellWithReuseIdentifier: UserStageCell.identifier)
        return cv
    }()
    
    public lazy var searchTableView: UITableView = {
        let tv = UITableView()
        tv.layer.cornerRadius = 20
        tv.clipsToBounds = true
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.brown02.cgColor
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.showsHorizontalScrollIndicator = false
        tv.register(UserSearchCell.self,
                    forCellReuseIdentifier: UserSearchCell.identifier)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        addConstraints()
    }
    
    private func addConstraints() {
        self.addSubview(navigationBar)
        self.addSubview(searchTextField)
        self.addSubview(inviteButton)
        self.addSubview(userStageCollectionView)
        self.addSubview(searchTableView)
        
        navigationBar.configureTitle(title: "초대하기")
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(31)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        addLeftViewInTextField()
        
        inviteButton.configure(labelText: "초대하기")
        inviteButton.available()
        inviteButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-53)
        }
        
        userStageCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(40)
            make.bottom.equalTo(inviteButton.snp.top).inset(-20)
        }
        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
    }
    
    // MARK: CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    private func addLeftViewInTextField() {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 30))
        let searchIcon = UIImageView().then {
            $0.image = .search
            $0.contentMode = .scaleAspectFit
        }
        leftView.addSubview(searchIcon)
        
        searchTextField.addSubview(searchIcon)
        
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        searchTextField.leftView = leftView
        searchTextField.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

import SwiftUI
#Preview {
    InviteUserViewController()
}
