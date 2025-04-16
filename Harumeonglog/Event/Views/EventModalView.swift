//
//  EventModalView.swift
//  Harumeonglog
//

import UIKit
import SnapKit

protocol EventModalViewDelegate: AnyObject {
    func didSelectCategory(_ category: String?) // 카테고리 선택 시 전달
}

class EventModalView: UIView {
    
    weak var delegate: EventModalViewDelegate?

    private let categories = ["전체", "위생", "건강", "산책", "기타"]
    private var selectedCategory: String? = "전체"

    // 일정 데이터 (외부에서 설정 가능)**
    var Events: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // 카테고리 필터 (UICollectionView)
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.isUserInteractionEnabled = true
        collectionView.delaysContentTouches = false

        return collectionView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70 // 셀 높이
        tableView.separatorStyle = .none //구분선 제거
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        tableView.backgroundColor = .clear
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
            make.bottom.equalToSuperview()
        }
        bringSubviewToFront(categoryCollectionView)

    }
}

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
        selectedCategory = (selectedCategory == category) ? "전체" : category // 선택 해제 시 전체 보기
        collectionView.reloadData()
        delegate?.didSelectCategory(selectedCategory) // 선택된 카테고리 전달
    }

    //  **카테고리 버튼 크기 조정**
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 30)
    }
}

extension EventModalView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate & DataSource
    
    // UITableView DataSource & Delegate (일정 리스트)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as! EventCell
        cell.configure(Event: Events[indexPath.row], isChecked: false) // 기본 체크 해제 상태
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
