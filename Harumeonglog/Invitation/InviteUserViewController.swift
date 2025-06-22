//
//  InviteUserViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/6/25.
//

import UIKit
import Combine

class InviteUserViewController: UIViewController {
    
    private let inviteUserView = InviteUserView()
    private let viewModel = InviteUserViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = inviteUserView
        setupBindings()
        setupDelegates()
        setupActions()
    }
    
    private func setupBindings() {
        viewModel.$isKeyboardVisible
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                self?.inviteUserView.searchTableView.isHidden = !isVisible
            }
            .store(in: &cancellables)
    }
        
    private func setupDelegates() {
        self.inviteUserView.searchTextField.delegate = self
        self.inviteUserView.userStageCollectionView.delegate = self
        self.inviteUserView.userStageCollectionView.dataSource = self
        self.inviteUserView.searchTableView.delegate = self
        self.inviteUserView.searchTableView.dataSource = self
    }
        
    private func setupActions() {
        self.inviteUserView.navigationBar.leftArrowButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    @objc
    private func popVC() {
        dismiss(animated: false)
    }
}

extension InviteUserViewController: UITextFieldDelegate {
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
}

extension InviteUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.stage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserStageCell.identifier, for: indexPath) as! UserStageCell
        let member = viewModel.stage[indexPath.row]
        cell.configure(data: member)
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

extension InviteUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchCell.identifier, for: indexPath) as! UserSearchCell
        let member = viewModel.searched[indexPath.row]
        // cell.configure(member: member) // 실제 Member 데이터로 구성
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMember = viewModel.searched[indexPath.row]
        viewModel.stage.append(selectedMember)
        
        // 검색 텍스트 필드 초기화 및 키보드 숨기기
        inviteUserView.searchTextField.text = ""
        inviteUserView.searchTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

import SwiftUI
#Preview {
    InviteUserViewController()
}
