//
//  EventView+UICollectionView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
//

import UIKit

extension EventView : UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryType.allCasesWithAll.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        let category = CategoryType.allCasesWithAll[indexPath.item]
        let isSelected = category == selectedCategory
        cell.configure(with: category?.displayName ?? "전체", isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = CategoryType.allCasesWithAll[indexPath.item]
        selectedCategory = category
        collectionView.reloadData()
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])

        if category == nil {
            delegate?.didSelectCategory("")
        } else {
            delegate?.didSelectCategory(category!.serverKey)
        }

        // 카테고리 선택 시 해당 카테고리에 맞는 일정 다시 호출
        if let parentVC = self.findViewController() as? HomeViewController {
            let selectedDate = parentVC.homeView.calendarView.selectedDate ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: selectedDate)

            guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
                print("AccessToken이 없음")
                return
            }

            let categoryKey = category?.serverKey
            EventService.getEventsByDate(date: dateString, category: categoryKey, token: token) { result in
                switch result {
                case .success(let response):
                    let events = response.result?.events?.map {
                        Event(id: $0.id, title: $0.title, category: category?.serverKey ?? "", done:$0.done)
                    } ?? []
                    DispatchQueue.main.async {
                        parentVC.homeView.eventView.updateEvents(events)
                    }
                    print("카테고리별 일정 조회 성공")
                case .failure(let error):
                    print("카테고리별 일정 조회 실패: \(error)")
                }
            }
        }
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}
