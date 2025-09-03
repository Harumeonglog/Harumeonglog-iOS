//
//  PetListViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/26/25.
//

import UIKit
import Combine

class PetListViewController: UIViewController, PetOwnerCellDelegate, PetGuestCellDelegate {
    
    var petListViewModel: PetListViewModel?
    var cancellables = Set<AnyCancellable>()
    private var workItem: DispatchWorkItem?
    
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
    }
    
    override func viewDidLayoutSubviews() {
        petListView.setConstraints()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configure(petListViewModel: PetListViewModel?) {
        self.petListViewModel = petListViewModel
        
        self.petListViewModel!.$petList
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.petListView.petListCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func showPetRegistrationVC() {
        let petRegistrationVC = EditOrRegistPetViewController()
        petRegistrationVC.configure(pet: nil, petListViewModel: petListViewModel!, mode: .Regist)
        self.navigationController?.pushViewController(petRegistrationVC, animated: true)
    }
    
    @objc
    private func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapInviteButton(petID: Int) {
        let invitationVC = InviteMemberViewController()
        invitationVC.modalPresentationStyle = .overFullScreen
        invitationVC.configure(petID: petID)
        present(invitationVC, animated: false)
    }
    
    func didTapExitButton(petID: Int) {
        petListViewModel!.deletePet(petId: petID) { _ in }
    }
    
    func didTapEditButton(pet: Pet) {
        let petEditViewController = EditOrRegistPetViewController()
        petEditViewController.configure(pet: pet, petListViewModel: petListViewModel!, mode: .Edit)
        self.navigationController?.pushViewController(petEditViewController, animated: true)
    }
    
    func didTapDeleteMemberButton() {
        petListView.petListCollectionView.reloadData()
    }
}

extension PetListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.petListViewModel!.petList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.petListViewModel!.petList[indexPath.row]
        switch data.role {
        case "OWNER":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetOwnerCell.self.identifier, for: indexPath) as! PetOwnerCell
            cell.configure(data, delegate: self, petListViewModel: petListViewModel)
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
        let data = self.petListViewModel!.petList[indexPath.row]
        switch data.role {
        case "OWNER":
            let _ = data.people?.count ?? 0
            let memberTableHeight: CGFloat = 156 // = min(CGFloat(3) * 52, 157)
            let baseHeight: CGFloat = 200 // 기본 높이 조정
            let totalHeight = baseHeight + memberTableHeight
            return CGSize(width: UIScreen.main.bounds.width - 40, height: totalHeight)
        default:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 120)
        }
    }
}

extension PetListViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 1.5 {
            workItem?.cancel()
            workItem = DispatchWorkItem { [weak self] in
                self?.petListViewModel!.getPetList{ _ in}
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem!)
        }
    }
    
}


enum UserAcessLevelEnum: String {
    case Owner, Guest
}

import SwiftUI
#Preview {
    PetListViewController()
}
