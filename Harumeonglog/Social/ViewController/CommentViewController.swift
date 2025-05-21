//
//  CommentViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/24/25.
//

import UIKit

class CommentViewController: UIViewController, UITextViewDelegate {
    
    let socialCommentService = SocialCommentService()
    var postId : Int?
    var commentText : String = ""
    private var comments: [CommentItem] = []
    private var cursor: Int = 0
    private var hasNext: Bool = true
    private var isFetching: Bool = false
    
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
        
        commentView.commentUploadButton.addTarget(self, action: #selector(commentUploadButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCommentsFromServer(reset: true)
    }
    
    private func fetchCommentsFromServer(reset: Bool = false) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
             print("토큰 없음")
             return
         }
        
        if isFetching { return }
        isFetching = true
        
        if reset {
            cursor = 0
            hasNext = true
            comments.removeAll()
            commentView.commentTableView.reloadData()
        }
        
        socialCommentService.getCommentListFromServer(postId: self.postId!, cursor: cursor, size: 10, token: token){ [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let response):
                if response.isSuccess {
                    if let commentList = response.result {
                        self.comments.append(contentsOf: commentList.items)

                        print("댓글 조회 성공: \(commentList.items.count)")
                        self.cursor = commentList.cursor ?? 0
                        self.hasNext = commentList.hasNext
                        
                        DispatchQueue.main.async {
                            self.commentView.commentTableView.reloadData()
                        }
                    } else {
                        print("결과 데이터가 비어있습니다.")
                    }
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("게시글 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    internal func textViewDidChange(_ textView: UITextView) {
        
        let isEmpty = commentView.commentTextView.text.isEmpty
        self.commentText = commentView.commentTextView.text
        
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
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func commentUploadButtonTapped() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
             print("토큰 없음")
             return
         }

        socialCommentService.postCommentToServer(postId: postId!, content: commentText, token: token)
        { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("댓글 생성 성공")
                    commentView.commentTextView.text = ""
                    fetchCommentsFromServer(reset: true)

                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("댓글 생성 실패: \(error.localizedDescription)")
            }
        }
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource, CommentTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = comments[indexPath.row]
        let commentReplies = comment.commentcommentResponseList
        
        if commentReplies.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            cell.selectionStyle = .none
            cell.configure(with: comment, member: comment.memberInfoResponse)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentTableViewCell", for: indexPath) as! ReplyCommentTableViewCell
            cell.selectionStyle = .none
            cell.configure(with: comment.commentcommentResponseList, member: comment.memberInfoResponse)
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
            
            commentView.commentTextView.typingAttributes = [
                .foregroundColor: UIColor.gray00,
                .font: UIFont.body
            ]
        }
    }
    
    // cell 의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
