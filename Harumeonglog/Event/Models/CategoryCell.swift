//
//  CategoryCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/15/25.
//

import UIKit
import SnapKit

// 카테고리 필터 셀 (UICollectionViewCell)**
class CategoryCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .description
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
    }

    func configure(with text: String, isSelected: Bool) {
        titleLabel.text = text
        contentView.backgroundColor = isSelected ? .brown01 : .brown02
        titleLabel.textColor = isSelected ? .white : .gray00
        contentView.layer.borderColor = isSelected ? UIColor.brown01.cgColor : UIColor.brown02.cgColor
        contentView.layer.borderWidth = 1
    }
}


enum EventCategory: String, CaseIterable {
    case all = "전체"
    case bath = "목욕"
    case walk = "산책"
    case hospital = "진료"
    case medicine = "약"
    case general = "기타"
    
    var displayName: String {
        return self.rawValue
    }
    
    var serverKey: String {
        switch self {
        case .bath: return "BATH"
        case .walk: return "WALK"
        case .hospital: return "HOSPITAL"
        case .medicine: return "MEDICINE"
        case .general: return "GENERAL"
        case .all:
            return "ALL"
        }
    }
}
