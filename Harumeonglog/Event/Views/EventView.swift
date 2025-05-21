//
//  EventView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/11/25.
// 카테고리 + 일정 목록 표시


import UIKit
import SnapKit

protocol EventViewDelegate: AnyObject {
    func didSelectEvent(_ event: Event)
    func didSelectCategory(_ category: String)
}

class EventView: UIView {

    weak var delegate: EventViewDelegate?
    
    private var allEvents: [Event] = []

    private let categories: [String] = ["전체", "산책", "목욕", "병원", "기타"]
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

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

    private var filteredEvents: [Event] = []
    private var selectedCategory: String? = "전체"

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
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(22)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }


    func updateEvents(_ events: [Event]) {
        self.allEvents = events
        applyCategoryFilter()
    }

    private func applyCategoryFilter() {
        filteredEvents = allEvents
        tableView.reloadData()
    }
}

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

extension EventView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        let Event = filteredEvents[indexPath.row]
        cell.configure(Event: Event.title, isChecked: false)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = filteredEvents[indexPath.row]
        delegate?.didSelectEvent(selectedEvent)
    }
}
