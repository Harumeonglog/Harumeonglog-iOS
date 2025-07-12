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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    public lazy var commentTextView = UITextView().then { textView in
        textView.textColor = .gray00
        textView.font = .body
        textView.layer.cornerRadius = 15
        textView.layer.borderColor = UIColor.brown00.cgColor
        textView.layer.borderWidth = 1
        textView.returnKeyType = .done
        textView.isScrollEnabled = false  // 자동으로 크기 조절
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 45+16) // 왼쪽 패딩 적용
    }
    
    public lazy var placeholderLabel = UILabel().then { label in
        label.text = "댓글을 달아주세요."
        label.textColor = .gray02
        label.font = .body
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
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(90)
        }
        
        self.addSubview(commentTextView)
        commentTextView.addSubview(placeholderLabel)
        self.addSubview(commentUploadButton)
        
        commentTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(40)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
        }
        
        commentUploadButton.snp.makeConstraints { make in
            make.trailing.equalTo(commentTextView.snp.trailing).offset(-10)
            make.bottom.equalTo(commentTextView.snp.bottom).offset(-5)
            make.width.equalTo(45)
            make.height.equalTo(30)
        }
        
        
        
        
        
        
    }
}
