//
//  CommentViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/24/25.
//

import UIKit

protocol MenuConfigurableCell {
    var settingButton: UIButton { get }
}

enum CommentDisplayItem {
    case comment(CommentItem)
    case reply(CommentcommentResponse)
}


class CommentViewController: UIViewController, UITextViewDelegate {

    private var commentDisplayItems: [CommentDisplayItem] = []
    private var comments: [CommentItem] = []
    private var replyComments : [CommentcommentResponse] = []
    
    let socialCommentService = SocialCommentService()
    var postId : Int?
    var commentId : Int?
    var commentText : String = ""

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
                        
                        for comment in commentList.items {
                            commentDisplayItems.append(.comment(comment))
                            for reply in comment.commentcommentResponseList {
                                commentDisplayItems.append(.reply(reply))
                            }
                        }

                        DispatchQueue.main.async {
                            self.commentView.commentTableView.reloadData()
                        }
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
        let item = commentDisplayItems[indexPath.row]
        
        switch item {
        case .comment(let comment):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            cell.selectionStyle = .none
            cell.configure(with: comment, member: comment.memberInfoResponse)
            configureSettingMenu(for: cell, commentId: comment.commentId)
            return cell
            
        case .reply(let reply):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentTableViewCell", for: indexPath) as! ReplyCommentTableViewCell
            cell.selectionStyle = .none
            cell.configure(with: reply, member: reply.memberInfoResponse)
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
                .font: UIFont(name: FontName.pretendard_light.rawValue, size: 12) as Any
            ], range: NSRange(location: 0, length: mentionText.count))
            
            commentView.commentTextView.attributedText = attributedString
            commentView.commentTextView.becomeFirstResponder() // 키보드 올리기
            
            commentView.commentTextView.typingAttributes = [
                .foregroundColor: UIColor.gray00,
                .font: UIFont.body
            ]
        }
    }
    
    func likeButtonTapped(in: CommentTableViewCell) {
    }
    
    func configureSettingMenu(for cell: MenuConfigurableCell, commentId: Int) {
        let handler: UIActionHandler = { [weak self] action in
            guard let self else { return }

            switch action.title {
            case "신고":
                print("신고")
                self.reportComment(commentId: commentId)
            case "차단":
                print("차단")
                self.blockComment(commentId: commentId)
            default:
                break
            }
        }
        
        let reportAction = makeAction(title: "신고", color: .gray00, handler: handler)
        let blockAction = makeAction(title: "차단", color: .gray00, handler: handler)

        let menu = UIMenu(options: .displayInline, children: [reportAction, blockAction])
        cell.settingButton.menu = menu
        cell.settingButton.showsMenuAsPrimaryAction = true
    }
    
    func reportComment(commentId: Int) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
             print("토큰 없음")
             return
         }
        
        socialCommentService.reportCommentToServer(commentId: commentId, token: token){ [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("댓글 신고 성공")
                    
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("댓글 생성 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func blockComment(commentId: Int) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
             print("토큰 없음")
             return
         }
        
        socialCommentService.blockCommentToServer(commentId:  commentId, token: token){ [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("댓글 차단 성공")
                    self!.fetchCommentsFromServer(reset: true)
                    
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("댓글 생성 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // cell 의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDisplayItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
