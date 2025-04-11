//
//  ScheduleView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/11/25.
//

import UIKit
import SnapKit

class ScheduleView: UIView {

    private let categoryCollectionView: UICollectionView = {
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
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        return tableView
    }()

    private var allSchedules: [Schedule] = [
        Schedule(category: "위생", title: "목욕하기", date: Date()),
        Schedule(category: "건강", title: "병원 가기", date: Date()),
        Schedule(category: "산책", title: "공원 산책", date: Date()),
        Schedule(category: "기타", title: "친구 만나기", date: Date()),
        Schedule(category: "건강", title: "운동하기", date: Date()),
        Schedule(category: "산책", title: "강아지랑 걷기", date: Date()),
        Schedule(category: "위생", title: "손톱 깎기", date: Date())
    ]

    private var filteredSchedules: [Schedule] = []
    private var selectedCategory: String? = "전체"

    private var categories: [String] {
        return ["전체"] + Array(Set(allSchedules.map { $0.category })).sorted()
    }

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

    func updateSchedules(for date: Date) {
        filteredSchedules = allSchedules.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        applyCategoryFilter()
    }

    private func applyCategoryFilter() {
        if selectedCategory == "전체" || selectedCategory == nil {
            filteredSchedules = allSchedules
        } else {
            filteredSchedules = allSchedules.filter { $0.category == selectedCategory }
        }
        tableView.reloadData()
        categoryCollectionView.reloadData()
    }
}

extension ScheduleView : UICollectionViewDelegate, UICollectionViewDataSource {
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

extension ScheduleView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSchedules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }
        let schedule = filteredSchedules[indexPath.row]
        cell.configure(schedule: schedule.title, isChecked: false)
        return cell
    }
}
