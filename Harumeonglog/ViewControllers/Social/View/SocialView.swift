//
//  SocialView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/20/25.
//

import UIKit
import SnapKit
import Then

class SocialView: UIView {
    public lazy var searchBar = UITextField().then { textfield in
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.brown02.cgColor
        textfield.layer.cornerRadius = 20
        textfield.clipsToBounds = true
    }
    
    public lazy var postTableView = UITableView().then { tableView in
        tableView.register(ImageViewCell.self, forCellReuseIdentifier: "ImageViewCell")
        tableView.register(TextOnlyCell.self, forCellReuseIdentifier: "TextOnlyCell")
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
    }
    
    private lazy var bottomLineView = UIView().then  { view in
        view.backgroundColor = UIColor.gray04
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addComponents() {
        
        self.addSubview(postTableView)
        
        postTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.leading.trailing.equalToSuperview().inset(22.5)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.addSubview(bottomLineView)
        
        bottomLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
