//
//  CommentView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/24/25.
//

import UIKit
import SnapKit
import Then

class CommentView: UIView {
    
    public lazy var navigationBar = CustomNavigationBar()

    public lazy var commentTableView = UITableView().then { tableView in
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        tableView.register(ReplyCommentTableViewCell.self, forCellReuseIdentifier: "ReplyCommentTableViewCell")
        
        tableView.backgroundColor = .background
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
    }
    
    public lazy var commentTextField = UITextField().then { textField in
        textField.textColor = .gray00
        textField.placeholder = "댓글을 달아주세요."
        textField.layer.cornerRadius = 15
        textField.layer.borderColor = UIColor.brown00.cgColor
        textField.layer.borderWidth = 1
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    public lazy var commentUploadButton = UIButton().then { button in
        button.setImage(UIImage(named: "commentUpload"), for: .normal)
        button.isHidden = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.addSubview(commentTableView)
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(25)
            make.height.lessThanOrEqualTo(620)
        }
        
        self.addSubview(commentTextField)
        commentTextField.addSubview(commentUploadButton)
        
        commentTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(40)
        }
        
        commentUploadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
            make.height.equalTo(30)
        }
        
        
        
        
        
        
    }
}
