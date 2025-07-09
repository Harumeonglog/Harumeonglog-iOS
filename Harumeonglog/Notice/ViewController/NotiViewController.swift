//
//  NotificationViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import UIKit
import Combine

class NotiViewController: UIViewController {
    
    private let notificationsView = NotiView()
    private let noticeViewModel = NoticeViewModel()
    private let invitationRequestViewModel = InvitationRequestsViewModel()
    private var cancellables: [AnyCancellable] = []
    private var workItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = notificationsView
        self.notificationsView.notificationCollectionView.delegate = self
        self.notificationsView.notificationCollectionView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        self.invitationRequestViewModel.getInvitationRequests()
        
        noticeViewModel.$notices
            .sink{ [weak self] _ in
                self?.notificationsView.notificationCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        invitationRequestViewModel.$invitations
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.notificationsView.configure(invitationCount: self?.invitationRequestViewModel.invitations.count)
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        notificationsView.setConstraints()
        notificationsView.toInvitationButton.addTarget(self, action: #selector(showInvitationVC), for: .touchUpInside)
        notificationsView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noticeViewModel.getNotices{ _ in }
    }
    
    @objc
    private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func showInvitationVC() {
        let invitationVC = InvitationRequestsViewController()
        invitationVC.configure(invitationRequestViewModel)
        self.navigationController?.pushViewController(invitationVC, animated: true)
    }
    
}

extension NotiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noticeViewModel.notices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotiCollectionViewCell.identifier, for: indexPath) as! NotiCollectionViewCell
        let data = noticeViewModel.notices[indexPath.row]
        cell.configure(data)
        return cell
    }
       
}

extension NotiViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 1.5 {
            workItem?.cancel()
            workItem = DispatchWorkItem { [weak self] in
                self?.noticeViewModel.getNotices{ _ in}
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem!)
        }
    }
    
}

import SwiftUI
#Preview {
    NotiViewController()
}
