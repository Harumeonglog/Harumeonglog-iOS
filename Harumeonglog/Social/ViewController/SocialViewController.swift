//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

class SocialViewController: UIViewController {

    private var selectedBtn: UIButton?      // 이전에 눌린 카테고리 버튼 저장
    
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
        navigationController?.pushViewController(addPostVC, animated: true)
    }

}


extension SocialViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20 + 100 + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetailVC = PostDetailViewController()
        postDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    
}

