//
//  EventView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/11/25.
//

import UIKit
import SnapKit

protocol EventViewDelegate: AnyObject {
    func didSelectEvent(_ event: Event)
}

class EventView: UIView {

    weak var delegate: EventViewDelegate?
    
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

    private var allEvents: [Event] = [
        Event(id: 0, title: "목욕하기", done: false, category: "위생"),
        Event(id: 1, title: "산책하기", done: false, category: "산책"),
        Event(id: 2, title: "병원가기", done: false, category: "건강"),
        Event(id: 3, title: "목욕하기", done: false, category: "기타")
        
    ]

    private var filteredEvents: [Event] = []
    private var selectedCategory: String? = "전체"

    private var categories: [String] { return ["전체"] + Array(Set(allEvents.map { $0.category })).sorted()}

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

    /*func updateEvents(for date: Date) {
        filteredEvents = allEvents.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        applyCategoryFilter()
    }*/

    private func applyCategoryFilter() {
        if selectedCategory == "전체" || selectedCategory == nil {
            filteredEvents = allEvents
        } else {
            filteredEvents = allEvents.filter { $0.category == selectedCategory }
        }
        tableView.reloadData()
        categoryCollectionView.reloadData()
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
        applyCategoryFilter()
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
