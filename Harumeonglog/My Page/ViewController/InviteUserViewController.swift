//
//  InviteUserViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/6/25.
//

import UIKit

class InviteUserViewController: UIViewController {
    
    private let inviteUserView = InviteUserView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = inviteUserView
        self.inviteUserView.searchTextField.delegate = self
        self.inviteUserView.userStageCollectionView.delegate = self
        self.inviteUserView.userStageCollectionView.dataSource = self
    }
}

extension InviteUserViewController: UITextFieldDelegate {
    
}

extension InviteUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserStageModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = UserStageModel.data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserStageCell.identifier, for: indexPath) as! UserStageCell
        cell.configure(data: data)
        return cell
    }

}

extension InviteUserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 50)
    }
}

import SwiftUI
#Preview {
    InviteUserViewController()
}
