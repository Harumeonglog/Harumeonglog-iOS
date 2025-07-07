//
//  LikedPostsView.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit

class LikedPostsView: UIView {
    
    public let navigationBar = CustomNavigationBar()
    
    public let likedPostsTableView = UITableView().then {
        $0.register(ImageViewCell.self, forCellReuseIdentifier: "ImageViewCell")
        $0.register(TextOnlyCell.self, forCellReuseIdentifier: "TextOnlyCell")
        $0.isScrollEnabled = true
        $0.separatorStyle = .none
        $0.backgroundColor = .background
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(navigationBar)
        self.addSubview(likedPostsTableView)
        
        navigationBar.configureTitle(title: "좋아요 누른 게시물")
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        likedPostsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
