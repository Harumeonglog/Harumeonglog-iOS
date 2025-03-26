//
//  PetListViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/26/25.
//

import UIKit

class PetListViewController: UIViewController {
    
    private let petListView = PetListView()
    
    let dataSource: [PetData] = [
        PetData(level: .Guest, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11"),
        PetData(level: .Owner, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11"),
        PetData(level: .Owner, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11"),
        PetData(level: .Guest, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11"),
        PetData(level: .Guest, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11"),
        PetData(level: .Owner, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11"),
        PetData(level: .Owner, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11"),
        PetData(level: .Guest, image: nil, name: "덕구", gender: "남", size: .middle, birthday: "2007.02.11"),
    ]
    
    override func viewDidLoad() {
        self.view = petListView
        petListView.petListCollectionView.delegate = self
        petListView.petListCollectionView.dataSource = self
        self.petListView.navigationBar.leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        petListView.setConstraints()
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetCollectionViewCell.self.identifier, for: indexPath) as! PetCollectionViewCell
        let data = dataSource[indexPath.row]
        cell.configure(data)
        return cell
    }
    
}

import SwiftUI
#Preview {
    PetListViewController()
}
