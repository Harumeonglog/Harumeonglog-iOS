//
//  InviteUserViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 4/6/25.
//

import UIKit
import Combine

class InviteMemberViewController: UIViewController {
    
    private var petId: Int?
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
        swipeRecognizer()
    }
    
    func configure(petId: Int) {
        self.petId = petId
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
        guard let petId = petId else { return }
        viewModel.inviteUsers(petId: petId) { [weak self] isSucceed in
            guard let self = self else { return }
            switch isSucceed {
            case true:
                // 모달 닫고 MyPage 탭으로 전환
                self.dismiss(animated: true) {
                    // 현재 활성 윈도우의 root가 탭바인지 확인
                    if let windowScene = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first(where: { $0.activationState == .foregroundActive }),
                       let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                       let tab = window.rootViewController as? UITabBarController {
                        tab.selectedIndex = 4
                        
                        // MyPage 탭이 내비게이션 컨트롤러라면 루트로 정리
                        if let myPageNav = tab.viewControllers?[4] as? UINavigationController {
                            myPageNav.popToRootViewController(animated: false)
                        }
                    } else {
                        // 폴백: 현재 컨텍스트에서 탭 전환 시도
                        self.tabBarController?.selectedIndex = 4
                    }
                }
                
            case false:
                let alert = UIAlertController(title: "초대 실패", message: "잠시 후 다시 시도해 주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
}

extension InviteMemberViewController {
    
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
    
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
