//
//  InviteUserViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/6/25.
//

import UIKit
import Combine

class InviteMemberViewController: UIViewController {
    
    private var petID: Int?
    private let inviteMemberView = InviteMemberView()
    private let viewModel = InviteMemberViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = inviteMemberView
        self.hideKeyboardWhenTappedAround()
        setupBindings()
        setupDelegates()
        setupActions()
    }
    
    func configure(petID: Int) {
        self.petID = petID
    }
    
    private func setupBindings() {
        viewModel.$isKeyboardVisible
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                self?.inviteMemberView.searchTableView.isHidden = !isVisible
            }
            .store(in: &cancellables)
        viewModel.$searched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.inviteMemberView.searchTableView.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$stage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.inviteMemberView.userStageCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupDelegates() {
        self.inviteMemberView.searchTextField.delegate = self
        self.inviteMemberView.userStageCollectionView.delegate = self
        self.inviteMemberView.userStageCollectionView.dataSource = self
        self.inviteMemberView.searchTableView.delegate = self
        self.inviteMemberView.searchTableView.dataSource = self
    }
    
    private func setupActions() {
        self.inviteMemberView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        self.inviteMemberView.inviteButton.addTarget(self, action: #selector(invite), for: .touchUpInside)
    }
    
    @objc
    private func popVC() {
        dismiss(animated: false)
    }
    
    @objc
    private func invite() {
        viewModel.inviteUsers(petID: petID!)
    }
    
}

extension InviteMemberViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.isSearching = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.isSearching = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 검색 로직 추가 (안해도 될듯)
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.search(textField.text ?? "")
        return true
    }
}

extension InviteMemberViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.stage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserStageCell.identifier, for: indexPath) as! UserStageCell
        let data = viewModel.stage[indexPath.row]
        cell.configure(data: data, delegate: self)
        return cell
    }
    
}

extension InviteMemberViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 50)
    }
    
}

extension InviteMemberViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchCell.identifier, for: indexPath) as! UserSearchCell
        let member = viewModel.searched[indexPath.row]
        cell.configure(with: member)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMember = viewModel.searched[indexPath.row]
        
        // 초대 대기 멤버로 추가
        viewModel.addToStage(selectedMember)
        
        // 검색 텍스트 필드 초기화 및 키보드 숨기기
        inviteMemberView.searchTextField.text = ""
        inviteMemberView.searchTextField.resignFirstResponder()
        
        // searchTableView 숨기기
        inviteMemberView.searchTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension InviteMemberViewController: UserStageCellDelegate {
    
    func userStageCell(_ cell: UserStageCell, didTapDeletionButtonFor member: Member) {
        print("stage user 삭제 버튼 누름")
    }
    
    func userStageCell(_ cell: UserStageCell, didChangeUserLevelFor member: Member) {
        viewModel.update(member: member)
    }
    
    
}

import SwiftUI
#Preview {
    InviteMemberViewController()
}
