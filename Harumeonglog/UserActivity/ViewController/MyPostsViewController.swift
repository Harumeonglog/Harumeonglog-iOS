//
//  MyPostsViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit

class MyPostsViewController: UIViewController {

    private var myPostsView = MyPostsView()
    private var userActivityViewModel: UserActivityViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPostsView
    }
    
}

extension MyPostsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
