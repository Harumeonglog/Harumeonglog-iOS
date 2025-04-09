//
//  CommentViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/24/25.
//

import UIKit

class CommentViewController: UIViewController, UITextViewDelegate {
    
    private lazy var commentView: CommentView = {
        let view = CommentView()
        view.backgroundColor = .background
        
        view.commentTableView.delegate = self
        view.commentTableView.dataSource = self
        view.commentTextView.delegate = self
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = commentView
        setCustomNavigationBarConstraints()
        hideKeyboardWhenTappedAround()
    }
    
    internal func textViewDidChange(_ textView: UITextView) {
        
        let isEmpty = commentView.commentTextView.text.isEmpty
        commentView.placeholderLabel.isHidden = !isEmpty
        commentView.commentUploadButton.isHidden = isEmpty
        
        
        let size = CGSize(width: commentView.commentTextView.frame.width, height: .infinity)
        let estimatedSize = commentView.commentTextView.sizeThatFits(size)
        
        commentView.commentTextView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = max(40, estimatedSize.height)
            }
        }
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

extension CommentViewController: UITableViewDelegate, UITableViewDataSource, CommentTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.delegate = self

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentTableViewCell", for: indexPath) as? ReplyCommentTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func replyButtonTapped(in cell: CommentTableViewCell) {
        if let indexPath = commentView.commentTableView.indexPath(for: cell) {
            print("댓글 \(indexPath.row)  버튼 클릭됨!")
            
            // commentTextfield에 @사용자이름 자동으로 입력
            let userName = cell.accountName.text ?? "익명"
            let mentionText = "@\(userName)  "
            
            let attributedString = NSMutableAttributedString(string: mentionText)
            attributedString.addAttributes([
                .foregroundColor: UIColor.gray02,
                .font: UIFont(name: FontName.pretendard_light.rawValue, size: 12)
            ], range: NSRange(location: 0, length: mentionText.count))
            
            commentView.commentTextView.attributedText = attributedString
            commentView.commentTextView.becomeFirstResponder() // 키보드 올리기
            
            // 사용자가 입력할 텍스트 스타일은 기본 스타일로 설정
            commentView.commentTextView.typingAttributes = [
                .foregroundColor: UIColor.gray00,
                .font: UIFont.body
            ]
        }
    }
    
    // cell 의 갯수
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
