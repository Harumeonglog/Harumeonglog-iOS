//
//  EventView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/11/25.
// 카테고리 + 일정 목록 표시

import Foundation
import UIKit
import SnapKit

protocol EventViewDelegate: AnyObject {
    func didSelectEvent(_ event: Event)
    func didSelectCategory(_ category: String)
}

class EventView: UIView {

    weak var delegate: EventViewDelegate?
    
    var allEvents: [Event] = []

    let categories: [CategoryType?] = CategoryType.allCasesWithAll
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        return tableView
    }()

     var filteredEvents: [Event] = []
     var selectedCategory: CategoryType? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(categoryCollectionView)
        addSubview(tableView)

        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
    }


    func updateEvents(_ events: [Event]) {
        print("updateEvents 호출됨: \(events.count)건")
        self.allEvents = events
        applyCategoryFilter()
    }

    func applyCategoryFilter() {
        if selectedCategory == nil {
            filteredEvents = allEvents
        } else {
            filteredEvents = allEvents.filter { $0.category == selectedCategory?.serverKey }
        }
        print("필터된 이벤트 수: \(filteredEvents.count)")

        tableView.reloadData()
    }
    
    func removeEvent(withId id: Int) {
        if let index = allEvents.firstIndex(where: { $0.id == id }) {
            allEvents.remove(at: index)
            applyCategoryFilter()
        } else {
            print("삭제할 이벤트가 allEvents에 없음: \(id)")
        }
    }
}
