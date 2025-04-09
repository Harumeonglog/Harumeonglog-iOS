//
//  PetListViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/26/25.
//

import UIKit

class PetListViewController: UIViewController {
    
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
    
    let dataSource: [PetData] = [
        PetData(level: .Owner, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11", people: [PetDataPerson(level: .Owner, name: "하민혁")]),
        PetData(level: .Owner, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11", people: [PetDataPerson(level: .Owner, name: "하민혁"), PetDataPerson(level: .Owner, name: "하민혁")]),
        PetData(level: .Owner, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11", people: nil),
        PetData(level: .Owner, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11", people: nil),
        PetData(level: .Guest, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11", people: nil),
        PetData(level: .Guest, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11", people: nil),
        PetData(level: .Guest, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11", people: nil),
        PetData(level: .Guest, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11", people: nil),
    ]
    
    override func viewDidLoad() {
        self.view = petListView
        petListView.petListCollectionView.delegate = self
        petListView.petListCollectionView.dataSource = self
        self.petListView.navigationBar.leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        self.petListView.addPetButton.addTarget(self, action: #selector(showPetRegistrationVC), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        petListView.setConstraints()
    }
    
    @objc
    private func showPetRegistrationVC() {
        let petRegistrationVC = PetRegistrationViewController()
        petRegistrationVC.modalPresentationStyle = .overFullScreen
        present(petRegistrationVC, animated: false)
    }
    
    @objc
    private func dismissViewController() {
        dismiss(animated: false)
    }
}

extension PetListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = dataSource[indexPath.row]
        switch data.level {
        case .Owner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetOwnerCell.self.identifier, for: indexPath) as! PetOwnerCell
            cell.configure(data)
            return cell
        case .Guest:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetGuestCell.self.identifier, for: indexPath) as! PetGuestCell
            cell.configure(data)
            return cell
        }
    }
}

extension PetListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = dataSource[indexPath.row]
        switch data.level {
        case .Owner:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 330)
        case .Guest:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 120)
        }
    }
}

struct PetData {
    let level: UserAcessLevelEnum
    let image: UIImage?
    let name: String
    let gender: String
    let size: DogSizeEnum
    let birthday: String
    let people: [PetDataPerson]?
}

struct PetDataPerson {
    let level: UserAcessLevelEnum
    let name: String
}

enum UserAcessLevelEnum: String {
    case Owner, Guest
}



import SwiftUI
#Preview {
    PetListViewController()
}
