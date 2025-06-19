//
//  PetListViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/26/25.
//

import UIKit
import Combine

class PetListViewController: UIViewController, PetOwnerCellDelegate, PetGuestCellDelegate {
    
    let petListViewModel = PetListViewModel()
    var cancellables = Set<AnyCancellable>()
    
    var petListDelegate: PetListViewControllerDelegate?
    var ownerCellDelegate: PetOwnerCellDelegate?
    var guestCellDelegate: PetGuestCellDelegate?
    
    public let showTabBar: (()->Void)? = nil
    private let petListView = PetListView()
    private let ownerLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 330)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 23
    }
    
    private let guestLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 120)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 23
    }
    
    override func viewDidLoad() {
        self.view = petListView
        petListView.petListCollectionView.delegate = self
        petListView.petListCollectionView.dataSource = self
        self.petListView.navigationBar.leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        self.petListView.addPetButton.addTarget(self, action: #selector(showPetRegistrationVC), for: .touchUpInside)
        
        petListViewModel.getPetList { result in
            switch result {
            case .none:
                break
            case .some(_):
                DispatchQueue.main.async {
                    self.petListView.petListCollectionView.reloadData()
                }
                break
            }
        }
        
        petListViewModel.$petList
            .sink { [weak self] _ in
                self?.petListView.petListCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        petListView.setConstraints()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc
    private func showPetRegistrationVC() {
        let petRegistrationVC = EditOrRegistPetViewController()
        petRegistrationVC.configure(pet: nil, petListViewModel: petListViewModel, mode: .Regist)
        self.navigationController?.pushViewController(petRegistrationVC, animated: true)
    }
    
    @objc
    private func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
        petListDelegate?.showTabBar()
    }
    
    func didTapInviteButton() {
        let invitationVC = InviteUserViewController()
        invitationVC.modalPresentationStyle = .overFullScreen
        present(invitationVC, animated: false)
    }
    
    func didTapExitButton(petID: Int) {
        petListViewModel.deletePet(petId: petID) { _ in }
    }
    
    func didTapEditButton(pet: Pet) {
        let petEditViewController = EditOrRegistPetViewController()
        petEditViewController.configure(pet: pet, petListViewModel: petListViewModel, mode: .Edit)
        self.navigationController?.pushViewController(petEditViewController, animated: true)
    }
}

extension PetListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.petListViewModel.petList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.petListViewModel.petList[indexPath.row]
        switch data.role {
        case "OWNER":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetOwnerCell.self.identifier, for: indexPath) as! PetOwnerCell
            cell.configure(data, delegate: self)
            return cell
        default :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetGuestCell.self.identifier, for: indexPath) as! PetGuestCell
            cell.configure(data, delegate: self)
            return cell
        }
    }
}

extension PetListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = self.petListViewModel.petList[indexPath.row]
        switch data.role {
        case "OWNER":
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 330)
        default :
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 120)
        }
    }
}

extension PetListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 1.5 {
            petListViewModel.getPetList { _ in }
        }
    }
    
}


enum UserAcessLevelEnum: String {
    case Owner, Guest
}

protocol PetListViewControllerDelegate {
    func showTabBar()
}

import SwiftUI
#Preview {
    PetListViewController()
}
