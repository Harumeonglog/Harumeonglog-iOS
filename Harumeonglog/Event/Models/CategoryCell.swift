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
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10) // 좌우 여백 추가
        }
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.brown02.cgColor
    }

    func configure(with text: String, isSelected: Bool) {
        titleLabel.text = text
        contentView.backgroundColor = isSelected ? .brown01 : .brown02
        titleLabel.textColor = isSelected ? .white : .gray00
        contentView.layer.borderColor = isSelected ? UIColor.brown01.cgColor : UIColor.brown02.cgColor

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
