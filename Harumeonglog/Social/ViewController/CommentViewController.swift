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
    var replyTargetCommentId : Int? = nil
    var commentText : String = ""
    var mentionRange: NSRange?

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
        swipeRecognizer()
        commentView.commentUploadButton.addTarget(self, action: #selector(commentUploadButtonTapped), for: .touchUpInside)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCommentsFromServer(reset: true)
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = commentView.navigationBar
        navi.configureTitle(title: "글 댓글")
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    

    private func fetchCommentsFromServer(reset: Bool = false) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {  return  }

        if isFetching { return }
        isFetching = true
        
        if reset {
            cursor = 0
            hasNext = true
            self.comments = []
            self.replyComments = []
            self.commentDisplayItems = []
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
                }
            case .failure(let error):
                print("게시글 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // 텍스트 변경될 때
    func textViewDidChange(_ textView: UITextView) {
        self.commentText = textView.text
        handleCommentTextViewUI()
    }

    // 멘션 백스페이스로 삭제할 때
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        if text.isEmpty,
           let mentionRange = self.mentionRange {
            if NSEqualRanges(range, NSRange(location: 0, length: textView.attributedText.length)) {
                // 전체 선택 후 삭제: 멘션 포함 전체 삭제
                textView.attributedText = NSAttributedString(string: "")
                self.mentionRange = nil
                handleCommentTextViewUI()
                return false
            }
            if NSIntersectionRange(range, mentionRange).length > 0 {
                // 멘션 영역 삭제 시 멘션 전체 삭제
                let mutable = NSMutableAttributedString(attributedString: textView.attributedText)
                mutable.replaceCharacters(in: mentionRange, with: "")
                textView.attributedText = mutable
                self.mentionRange = nil
                handleCommentTextViewUI()
                return false
            }
        }
        return true
    }


    private func handleCommentTextViewUI() {
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height

        commentView.commentTextViewBottomConstraint?.update(inset: keyboardHeight + 16)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        commentView.commentTextViewBottomConstraint?.update(inset: 50)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


// MARK: @Objc
extension CommentViewController {
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func commentUploadButtonTapped() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {  return  }

        let parentId: Int? = replyTargetCommentId
        
        if let mentionRange = self.mentionRange,
           let text = commentView.commentTextView.text,
           let swiftRange = Range(mentionRange, in: text) {
            // 멘션 이후 텍스트만 추출
            self.commentText = String(text[swiftRange.upperBound...])
        }
        socialCommentService.postCommentToServer(postId: postId!, parentId: parentId, content: commentText, token: token)
        { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):

                if response.isSuccess {
                    print("댓글 생성 성공")
                    DispatchQueue.main.async {
                        self.commentView.commentTextView.text = ""
                        self.commentView.placeholderLabel.isHidden = false
                        self.commentView.commentUploadButton.isHidden = true
                        //  높이 다시 40으로 고정
                        for constraint in self.commentView.commentTextView.constraints {
                            if constraint.firstAttribute == .height {
                                constraint.constant = 40
                            }
                        }
                        self.commentView.layoutIfNeeded()
                    }
                    self.fetchCommentsFromServer(reset: true)
                }
            case .failure(let error):
                print("댓글 생성 실패: \(error.localizedDescription)")
            }
        }
    }
}


// MARK: cell 안에 동작들
extension CommentViewController {
    
    func replyButtonTapped(in cell: CommentTableViewCell) {
        if let indexPath = commentView.commentTableView.indexPath(for: cell) {
            
            // 대댓글 대상 commentId 저장
            let comment = commentDisplayItems[indexPath.row]
            if case .comment(let commentItem) = comment {
                self.replyTargetCommentId = commentItem.commentId
            }
            
            commentView.placeholderLabel.isHidden = true
            commentView.commentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 61)

            // commentTextfield에 @사용자이름 자동으로 입력
            let userName = cell.accountName.text ?? "익명"
            let mentionText = "@\(userName)  "
            
            let attributedString = NSMutableAttributedString(string: mentionText)
            attributedString.addAttributes([
                .foregroundColor: UIColor.gray01,
                .font: UIFont(name: FontName.pretendard_light.rawValue, size: 14) as Any
            ], range: NSRange(location: 0, length: mentionText.count))
            
            self.mentionRange = NSRange(location: 0, length: mentionText.count)
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
    
    func configureSettingMenu(for cell: MenuConfigurableCell, commentId: Int, memberId: Int, isOwn: Bool) {
        let handler: UIActionHandler = { [weak self] action in
            guard let self else { return }
            switch action.title {
            case "신고":
                print("신고")
                self.reportComment(commentId: commentId)
            case "사용자 차단":
                showBlockAlertView(reportedId: memberId)
                self.fetchCommentsFromServer(reset: true)
            default:
                break
            }
        }
        let reportAction = makeAction(title: "신고", color: .gray00, handler: handler)
        let blockAction = makeAction(title: "차단", color: .gray00, handler: handler)
        let blockMemberAction = makeAction(title: "사용자 차단", color: .gray00, handler: handler)

        let actions: [UIAction]
        if !isOwn {
            actions = [reportAction, blockMemberAction]
        } else {
            return
        }
        
        let menu = UIMenu(options: .displayInline, children: actions)
        cell.settingButton.menu = menu
        cell.settingButton.showsMenuAsPrimaryAction = true
    }
    
    func reportComment(commentId: Int) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {  return  }

        socialCommentService.reportCommentToServer(commentId: commentId, token: token){ [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("댓글 신고 성공")
                    self!.fetchCommentsFromServer(reset: true)
                }
            case .failure(let error):
                print("댓글 생성 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func blockComment(commentId: Int) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {  return  }

        socialCommentService.blockCommentToServer(commentId:  commentId, token: token){ [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("댓글 차단 성공")
                    self!.fetchCommentsFromServer(reset: true)
                }
            case .failure(let error):
                print("댓글 생성 실패: \(error.localizedDescription)")
            }
        }
    }
    

}



// MARK: tableView 설정
extension CommentViewController: UITableViewDelegate, UITableViewDataSource, CommentTableViewCellDelegate {
    func accountImageViewTapped(in: CommentTableViewCell) {
        showBlockAlertView(reportedId: 4)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = commentDisplayItems[indexPath.row]
        
        switch item {
        case .comment(let comment):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.configure(with: comment, member: comment.memberInfoResponse)
            configureSettingMenu(for: cell, commentId: comment.commentId, memberId: comment.memberInfoResponse.memberId, isOwn: comment.isOwn)
            return cell
            
        case .reply(let reply):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentTableViewCell", for: indexPath) as! ReplyCommentTableViewCell
            cell.selectionStyle = .none
            cell.configure(with: reply, member: reply.memberInfoResponse)
            configureSettingMenu(for: cell, commentId: reply.commentId, memberId: reply.memberInfoResponse.memberId, isOwn: reply.isOwn)
            return cell
        }
    }
    
    // cell 의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDisplayItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
