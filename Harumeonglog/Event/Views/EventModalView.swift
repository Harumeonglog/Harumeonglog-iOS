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

     let categories = ["전체", "위생", "건강", "산책", "기타"]
     var selectedCategory: String? = "전체"

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
        delegate?.didSelectCategory(selectedCategory)
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
