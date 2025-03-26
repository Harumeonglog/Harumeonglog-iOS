//
//  NotificationViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/23/25.
//

import UIKit

class NotiViewController: UIViewController {
    
    private let notificationsView = NotiView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = notificationsView
        self.notificationsView.notificationCollectionView.delegate = self
        self.notificationsView.notificationCollectionView.dataSource = self
        self.notificationsView.configure(invitationCount: 10)
    }
    
    override func viewDidLayoutSubviews() {
        notificationsView.setConstraints()
    }
    
}

extension NotiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NotiModelList.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotiCollectionViewCell.identifier, for: indexPath) as! NotiCollectionViewCell
        let data = NotiModelList.data[indexPath.row]
        cell.configure(data)
        return cell
    }
    
    
}

import SwiftUI
#Preview {
    NotiViewController()
}
