//
//  EventView+UICollectionView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
//

import UIKit

extension EventView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        let isSelected = category == selectedCategory
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        if let selected = selectedCategory {
            delegate?.didSelectCategory(selected)
        }
    }
}

