//
//  CommentViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/24/25.
//

import UIKit

class CommentViewController: UIViewController {
        
    private lazy var commentView: CommentView = {
        let view = CommentView()
        view.backgroundColor = .background
        
        view.commentTableView.delegate = self
        view.commentTableView.dataSource = self
        
        view.commentTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = commentView
        setCustomNavigationBarConstraints()
    }
    
    @objc private func textFieldDidChange() {
        let isEmpty = commentView.commentTextField.text?.isEmpty ?? true
        commentView.commentUploadButton.isHidden = isEmpty
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = commentView.navigationBar
        navi.configureTitle(title: "글 댓글")
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
