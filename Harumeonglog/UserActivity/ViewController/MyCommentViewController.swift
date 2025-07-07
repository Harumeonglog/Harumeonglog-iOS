//
//  MyCommentViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit
import Combine

final class MyCommentViewController: UIViewController {
    
    private let myCommentsView = MyCommentsView()
    private var userActivityViewModel: UserActivityViewModel?
    private var myComments: [MyCommentItem] = []
    
    var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myCommentsView
        
        self.myCommentsView.myCommentsTableView.delegate = self
        self.myCommentsView.myCommentsTableView.dataSource = self
        
        self.myCommentsView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userActivityViewModel?.getMyComments()
    }
    
    func configure(with viewModel: UserActivityViewModel) {
        self.userActivityViewModel = viewModel
        
        viewModel.$myComments
            .sink{ [weak self] myComments in
                self?.myComments = myComments
                self?.myCommentsView.myCommentsTableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    @objc
    private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = myComments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCommentCell.identifier, for: indexPath) as! MyCommentCell
        cell.selectionStyle = .none
        cell.configure(comment: data)
        return cell
    }
    
}
