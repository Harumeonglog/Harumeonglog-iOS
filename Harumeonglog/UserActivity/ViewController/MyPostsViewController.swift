//
//  MyPostsViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit
import Combine

final class MyPostsViewController: UIViewController {

    private var myPostsView = MyPostsView()
    private var userActivityViewModel: UserActivityViewModel?
    private var myPosts: [PostItem] = []
    
    var cancellable: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPostsView
        
        self.myPostsView.myPostsTableView.delegate = self
        self.myPostsView.myPostsTableView.dataSource = self
        
        self.myPostsView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        
        swipeRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userActivityViewModel?.refreshMyPosts()
    }
    
    func configure(with viewModel: UserActivityViewModel) {
        self.userActivityViewModel = viewModel
        
        viewModel.$myPosts
            .sink{ [weak self] myPosts in
                self?.myPosts = myPosts
                self?.myPostsView.myPostsTableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    @objc
    private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyPostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = myPosts[indexPath.row]
        
        if let imageKey = post.imageKeyName, !imageKey.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
            cell.selectionStyle = .none
            cell.configure(with: post)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextOnlyCell", for: indexPath) as! TextOnlyCell
            cell.selectionStyle = .none
            cell.configure(with: post)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20 + 90 + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = myPosts[indexPath.row]
        let postDetailVC = PostDetailViewController()
        postDetailVC.postId = post.postId
        postDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
}
