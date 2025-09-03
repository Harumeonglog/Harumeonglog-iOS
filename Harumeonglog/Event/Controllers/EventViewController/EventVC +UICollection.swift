//
//  EventView+UICollectionView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
// 홈화면에서 category 선택했을때

import UIKit

extension EventView : UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        let category = CategoryType.allCases[indexPath.item]
        let isSelected = category == selectedCategory
        cell.configure(with: category.displayName, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = CategoryType.allCases[indexPath.item]

        if selectedCategory == category {
            // 동일 카테고리 다시 탭하면 전체 보기로 전환
            selectedCategory = nil
            collectionView.reloadData()
            delegate?.didSelectCategory("")
        } else {
            selectedCategory = category
            collectionView.reloadData()
            delegate?.didSelectCategory(category.serverKey)
        }

        // 선택된 카테고리로 로컬 필터링 적용
        applyCategoryFilter()
        
        // 서버에서 카테고리별 일정 다시 가져오기
        if let parentVC = self.findViewController() as? HomeViewController {
            let selectedDate = parentVC.homeView.calendarView.selectedDate ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: selectedDate)

            guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
                print("AccessToken이 없음")
                return
            }

            let categoryKey = selectedCategory?.serverKey
            EventService.getEventsByDate(date: dateString, category: categoryKey, token: token) { [weak self] result in
                switch result {
                case .success(let response):
                    if let eventDates = response.result?.events {
                        let events = eventDates.map { eventDate in
                            // EventDate에는 category가 없으므로, 선택된 카테고리나 기본값 사용
                            let eventCategory = self?.selectedCategory?.serverKey ?? "OTHER"
                            return Event(id: eventDate.id, title: eventDate.title, category: eventCategory, done: eventDate.done)
                        }
                        DispatchQueue.main.async {
                            parentVC.homeView.eventView.updateEvents(events)
                        }
                        print("카테고리별 일정 조회 성공: \(category.rawValue), \(events.count)건")
                    } else {
                        DispatchQueue.main.async {
                            parentVC.homeView.eventView.updateEvents([])
                        }
                        print("카테고리별 일정 조회 성공: \(category.rawValue), 0건")
                    }
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
