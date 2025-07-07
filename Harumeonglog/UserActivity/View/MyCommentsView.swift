//
//  MyCommentsView.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit

class MyCommentsView: UIView {
    
    public let navigationBar = CustomNavigationBar()
    
    public let myCommentsTableView = UITableView().then {
        $0.register(MyCommentCell.self, forCellReuseIdentifier: MyCommentCell.identifier)
        $0.isScrollEnabled = true
        $0.separatorStyle = .none
        $0.backgroundColor = .background
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        
        self.addSubview(navigationBar)
        self.addSubview(myCommentsTableView)
        
        navigationBar.configureTitle(title: "내가 쓴 댓글")
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        myCommentsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
