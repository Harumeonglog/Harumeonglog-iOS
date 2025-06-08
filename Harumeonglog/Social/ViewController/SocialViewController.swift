//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

class SocialViewController: UIViewController {

    let socialPostService = SocialPostService()
    private var searchText: String? = nil
    
    private var selectedBtn: UIButton?      // 이전에 눌린 카테고리 버튼 저장
    private var selectedCategory: String = "ALL"
    private var posts: [PostItem] = []
    private var cursor: Int = 0
    private var hasNext: Bool = true
    private var isFetching: Bool = false
    
    
    private lazy var socialView: SocialView = {
        let view = SocialView()
        view.backgroundColor = .background
        
        view.postTableView.delegate = self
        view.postTableView.dataSource = self
        
        view.searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        view.searchCancelButton.addTarget(self, action: #selector(searchCancelButtonTapped), for: .touchUpInside)
        view.forEachButton { button in
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        }
        view.addPostButton.addTarget(self, action: #selector(addPostButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = socialView
        hideKeyboardWhenTappedAround()
        // fetchPostsFromServer(reset: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPostsFromServer(reset: true)
    }
    

    
    private func fetchPostsFromServer(reset: Bool = false, search: String? = nil) {
                
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
             print("토큰 없음")
             return
         }
        
        if isFetching { return }        // 중복 호출 방지
        isFetching = true
        
        if reset {
            cursor = 0
            hasNext = true
            posts.removeAll()
            socialView.postTableView.reloadData()
        }
        
        socialPostService.getPostListFromServer(
            search: search,
            postRequestCategory: selectedCategory,
            cursor: cursor,
            size: 5,
            token: token
        ) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let response):
                if response.isSuccess {
                    if let postList = response.result {
                        print("게시글 조회 성공: \(postList.items.count)")
                        self.posts.append(contentsOf: postList.items)
                        self.cursor = postList.cursor ?? 0
                        self.hasNext = postList.hasNext
                        DispatchQueue.main.async {
                            self.socialView.postTableView.reloadData()
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
    
    @objc private func textFieldDidChange() {
        let isEmpty = socialView.searchBar.text?.isEmpty ?? true
        socialView.searchCancelButton.isHidden = isEmpty
    }

    @objc private func searchButtonTapped() {
        self.searchText = socialView.searchBar.text ?? ""
        print("검색단어: \(self.searchText ?? "")")
        
        fetchPostsFromServer(reset: true, search: self.searchText)
    }
    
    @objc private func searchCancelButtonTapped() {
        socialView.searchBar.text = ""
        socialView.searchCancelButton.isHidden = true
        hideKeyboardWhenTappedAround()
        
        // 검색 결과 초기화 !! 필요함 
        fetchPostsFromServer(reset: true)
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        let senderTitle = sender.titleLabel?.text ?? ""
        let tappedCategory = socialCategoryKey.tagsKortoEng[senderTitle] ?? "unknown"
        
        if selectedCategory == tappedCategory {
            // 버튼 스타일 초기화
            sender.backgroundColor = .brown02
            sender.tintColor = .gray00
            sender.titleLabel?.font = UIFontMetrics.default.scaledFont(
                for: UIFont(name: "Pretendard-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
            )
            
            // 선택 해제 처리
            selectedBtn = nil
            selectedCategory = "ALL"
            fetchPostsFromServer(reset: true, search: self.searchText)
            return
        }
        
        if let previousBtn = selectedBtn {
            previousBtn.backgroundColor = .brown02
            previousBtn.tintColor = .gray00
            previousBtn.titleLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "Pretendard-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13))
        }
        
        sender.backgroundColor = .brown01
        sender.tintColor = .white
        sender.titleLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "Pretendard-Bold", size: 13) ?? UIFont.systemFont(ofSize: 13))
        sender.titleLabel?.adjustsFontSizeToFitWidth = false
        
        selectedBtn = sender
        selectedCategory = tappedCategory

        fetchPostsFromServer(reset: true, search: self.searchText)
        
    }
    
    
    @objc private func addPostButtonTapped() {
        let addPostVC = AddPostViewController()
        addPostVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addPostVC, animated: true)
    }

}


extension SocialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 마지막 셀이 화면에 보일 떄 다음 데이터 요청
        if indexPath.row == posts.count - 1 && hasNext {
            fetchPostsFromServer()
         }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let imageKey = post.imageKeyName, !imageKey.isEmpty {
            // 이미지가 있는 경우
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
            cell.selectionStyle = .none
            cell.configure(with: post)
            
            return cell
        } else {
            // 이미지가 없는 경우
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextOnlyCell", for: indexPath) as! TextOnlyCell
            cell.selectionStyle = .none
            cell.configure(with: post)
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20 + 90 + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let postDetailVC = PostDetailViewController()
        postDetailVC.postId = post.postId
        print("\(post.postId)")
        postDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postDetailVC, animated: true)
    }

    
}

