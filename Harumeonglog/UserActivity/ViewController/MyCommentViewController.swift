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
    private var cellHeights: [Int: CGFloat] = [:] // 셀 높이 캐싱
    
    var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myCommentsView
        
        self.myCommentsView.myCommentsTableView.delegate = self
        self.myCommentsView.myCommentsTableView.dataSource = self
        
        self.myCommentsView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        
        // 동적 높이 설정
        self.myCommentsView.myCommentsTableView.rowHeight = UITableView.automaticDimension
        self.myCommentsView.myCommentsTableView.estimatedRowHeight = 90
        
        swipeRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userActivityViewModel?.getMyComments()
    }
    
    func configure(with viewModel: UserActivityViewModel) {
        self.userActivityViewModel = viewModel
        viewModel.$myComments
            .sink { [weak self] myComments in
                self?.myComments = myComments
                self?.cellHeights.removeAll() // 높이 캐시 초기화
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 캐시된 높이가 있으면 사용, 없으면 계산
        if let cachedHeight = cellHeights[indexPath.row] {
            return cachedHeight
        }
        
        let data = myComments[indexPath.row]
        let font = UIFont(name: FontName.pretendard_light.rawValue, size: 13) ?? UIFont.systemFont(ofSize: 13)
        let textWidth = UIScreen.main.bounds.width - 40 - 8 - 16
        let textHeight = data.content.height(withConstrainedWidth: textWidth, font: font, lineHeight: 16)
        
        let calculatedHeight = max(90, 60 + textHeight)
        cellHeights[indexPath.row] = calculatedHeight
        
        return calculatedHeight
    }
    
    // 셀이 화면에서 사라질 때 높이 캐시 정리 (메모리 최적화)
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 필요에 따라 캐시 정리
        if indexPath.row >= myComments.count {
            cellHeights.removeValue(forKey: indexPath.row)
        }
    }

}
