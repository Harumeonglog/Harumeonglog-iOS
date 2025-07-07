//
//  LikedPostViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit

class LikedPostsViewController: UIViewController {
    
    private var likedPostsView = LikedPostsView()
    private var userActivityViewModel: UserActivityViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = likedPostsView
    }
    
}

extension LikedPostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userActivityViewModel?.likedPosts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = userActivityViewModel!.likedPosts[indexPath.row]
        
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
    
}
