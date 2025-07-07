//
//  LikedPostViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit
import Combine

final class LikedPostsViewController: UIViewController {
    
    private var likedPostsView = LikedPostsView()
    private var userActivityViewModel: UserActivityViewModel?
    private var likedPosts: [PostItem] = []
    
    var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = likedPostsView
        
        self.likedPostsView.likedPostsTableView.delegate = self
        self.likedPostsView.likedPostsTableView.dataSource = self
        
        self.likedPostsView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userActivityViewModel?.getLikedPosts()
    }
    
    func configure(with viewModel: UserActivityViewModel) {
        self.userActivityViewModel = viewModel
        
        viewModel.$likedPosts
            .sink{ [weak self] likedPosts in
                self?.likedPosts = likedPosts
                self?.likedPostsView.likedPostsTableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    @objc
    private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension LikedPostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = likedPosts[indexPath.row]
        
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
        let post = likedPosts[indexPath.row]
        let postDetailVC = PostDetailViewController()
        postDetailVC.postId = post.postId
        postDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
}
