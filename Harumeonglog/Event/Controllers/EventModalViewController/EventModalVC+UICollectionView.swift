//
//  EventModalView+UICollectionView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
// 카테고리 선택 및 UI 처리

import UIKit

extension EventModalView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.item]
        cell.configure(with: category, isSelected: category == selectedCategory)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        selectedCategory = category
        collectionView.reloadData()
        delegate?.didSelectCategory(selectedCategory) // 선택된 카테고리 전달
    }

    //  **카테고리 버튼 크기 조정**
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 30)
    }
}
