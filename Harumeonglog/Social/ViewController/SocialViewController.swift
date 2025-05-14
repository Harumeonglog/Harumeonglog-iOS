//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

class SocialViewController: UIViewController {

    let socialPostService = SocialPostService()
    private var selectedBtn: UIButton?      // 이전에 눌린 카테고리 버튼 저장
    
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
        fetchPostsFromServer(reset: true)

    }
    
    private func fetchPostsFromServer(reset: Bool = false) {
        let getAll = "ALL"
        
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
            search: nil,
            postRequestCategory: getAll,
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
                        print("게시글 조회 성공: \(postList)")
                        self.posts.append(contentsOf: postList.items.compactMap { $0 } ?? [])
                        self.cursor = postList.cursor!
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

    @objc private func searchCancelButtonTapped() {
        socialView.searchBar.text = ""
        socialView.searchCancelButton.isHidden = true
        hideKeyboardWhenTappedAround()
        
        // 검색 결과 초기화 !! 필요함 
        socialView.postTableView.reloadData()       // UI 업데이트
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
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
        if indexPath.row < 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextOnlyCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20 + 100 + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetailVC = PostDetailViewController()
        postDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    
}

