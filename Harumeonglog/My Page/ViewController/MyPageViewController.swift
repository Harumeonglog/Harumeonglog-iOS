//
//  BaseViewControllers.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit
import Combine

class MyPageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let myPageView = MyPageView()
    private var petListViewModel = PetListViewModel()
    private let userActivityViewModel = UserActivityViewModel()
    private let petListVC = PetListViewController()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPageView
        self.myPageView.previewPetListTableView.delegate = self
        self.myPageView.previewPetListTableView.dataSource = self
        setButtonActions()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        userActivityViewModel.getmyPosts()
        userActivityViewModel.getLikedPosts()
    }
    
    override func viewDidLayoutSubviews() {
        myPageView.setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        petListViewModel.getPetList{ _ in }
        MemberAPIService.getInfo { code, info in
            switch code {
            case .COMMON200:
                if let userInfo = MemberAPIService.userInfo {
                    self.myPageView.configure(userInfo)
                }
            case .AUTH401:
                RootViewControllerService.toLoginViewController()
            case .ERROR500, .AUTH400:
                print(code)
                break
            }
        }
        petListViewModel.$petList
            .sink { [weak self] _ in
                self?.myPageView.previewPetListTableView.reloadData()
            }
            .store (in: &cancellables)
            
        showTabBar()
    }
    
    private func setButtonActions() {
        myPageView.goNotification.addTarget(self, action: #selector(goToNotificationSettingVC), for: .touchUpInside)
        myPageView.goEditProileButton.addTarget(self, action: #selector(handleEditProfileButtonTapped), for: .touchUpInside)
        myPageView.goToPetListButton.addTarget(self, action: #selector(handlePetLisstButtonTapped), for: .touchUpInside)
        myPageView.logoutButton.addTarget(self, action: #selector(handleLogoutButtonTapped), for: .touchUpInside)
        myPageView.revokeButton.addTarget(self, action: #selector(handleRevokeButtonTapped), for: .touchUpInside)
    }
    
    func configure(petListViewModel: PetListViewModel) {
        self.petListViewModel = petListViewModel
    }
    
    @objc
    private func goToNotificationSettingVC() {
        let notiVC = DetailSettingViewController()
        self.navigationController?.pushViewController(notiVC, animated: true)
    }
    
    @objc
    private func handleEditProfileButtonTapped() {
        let editVC = EditProfileViewController()
        editVC.configure()
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc
    private func handlePetLisstButtonTapped() {
        petListVC.configure(petListViewModel: petListViewModel)
        self.navigationController?.pushViewController(petListVC, animated: true)
    }
    
    @objc
    private func handleLogoutButtonTapped() {
        AuthAPIService.logout { code in
            switch code {
            case .COMMON200:
                RootViewControllerService.toLoginViewController()
                let _ = KeychainService.delete(key: K.Keys.accessToken)
                let _ = KeychainService.delete(key: K.Keys.refreshToken)
            case .AUTH400:
                break
            }
        }
    }
    
    @objc
    private func handleRevokeButtonTapped() {
        AuthAPIService.revoke { code in
            switch code {
            case .COMMON200:
                RootViewControllerService.toLoginViewController()
                let _ = KeychainService.delete(key: K.Keys.accessToken)
                let _ = KeychainService.delete(key: K.Keys.refreshToken)
            case .AUTH400:
                break
            }
        }
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petListViewModel.petList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = petListViewModel.petList[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PreviewPetCell.identifier) as? PreviewPetCell else {
            return UITableViewCell()
        }
        cell.configure(with: data)
        return cell
    }
    
}
