//
//  InvitationViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/19/25.
//

import UIKit

class InvitationRequestsViewController: UIViewController {
    
    private let invitationRequestsView = InvitationRequestsView()
    private var invitationRequestsViewModel: InvitationRequestsViewModel?
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        self.view = invitationRequestsView
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        invitationRequestsView.setConstraints()
        invitationRequestsView.invitationMessageCollectionView.delegate = self
        invitationRequestsView.invitationMessageCollectionView.dataSource = self
        invitationRequestsView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        self.invitationRequestsViewModel?.getInvitationRequests()
    }
    
    func configure(_ viewModel: InvitationRequestsViewModel) {
        self.invitationRequestsViewModel = viewModel
    }
    
    @objc
    private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension InvitationRequestsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return invitationRequestsViewModel?.invitations.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitationRequestCell.self.identifier, for: indexPath) as! InvitationRequestCell
        let data = invitationRequestsViewModel!.invitations[indexPath.row]
        cell.configure(data, delegate: self)
        return cell
    }
    
}

extension InvitationRequestsViewController: InviteRequestCellDelegate {
    
    func didTapConfirmButton(of request: InvitationRequest) {
        invitationRequestsViewModel?.postInvitationResponse(request: request, mode: .accept)
    }
    
    func didTapDeleteButton(of request: InvitationRequest) {
        invitationRequestsViewModel?.postInvitationResponse(request: request, mode: .reject)
    }
    
}

import SwiftUI
#Preview {
    InvitationRequestsViewController()
}
