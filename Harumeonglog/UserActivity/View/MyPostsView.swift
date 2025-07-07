//
//  MyPostsView.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit

class MyPostsView: UIView {
    
    public let navigationBar = CustomNavigationBar()
    
    public let myPostsTableView = UITableView().then {
        $0.register(ImageViewCell.self, forCellReuseIdentifier: "ImageViewCell")
        $0.register(TextOnlyCell.self, forCellReuseIdentifier: "TextOnlyCell")
        $0.isScrollEnabled = true
        $0.separatorStyle = .none
        $0.backgroundColor = .background
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        
        self.addSubview(navigationBar)
        self.addSubview(myPostsTableView)
        
        navigationBar.configureTitle(title: "내가 쓴 게시물")
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        myPostsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(23)
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
