//
//  InvitationViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/19/25.
//

import UIKit

class InvitationViewController: UIViewController {
    
    private let invitationView = InvitationView()
    
    override func viewDidLoad() {
        self.view = invitationView
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        invitationView.setConstraints()
        invitationView.invitationMessageCollectionView.delegate = self
        invitationView.invitationMessageCollectionView.dataSource = self
        invitationView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    @objc
    private func popVC() {
        dismiss(animated: false)
    }
    
}

extension InvitationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InvitationModelList.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitationCell.self.identifier, for: indexPath) as! InvitationCell
        let data = InvitationModelList.data[indexPath.row]
        cell.configure(data)
        return cell
    }
    
}

import SwiftUI
#Preview {
    InvitationViewController()
}
