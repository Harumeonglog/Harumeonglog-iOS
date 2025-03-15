//
//  CategoryCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/15/25.
//

import UIKit
import SnapKit

// ✅ **카테고리 필터 셀 (UICollectionViewCell)**
class CategoryCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = K.Font.description
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
        contentView.layer.borderColor = UIColor.blue02.cgColor
    }

    func configure(with text: String, isSelected: Bool) {
        titleLabel.text = text
        contentView.backgroundColor = isSelected ? .blue01 : .blue02
        titleLabel.textColor = isSelected ? .white : .gray00
        contentView.layer.borderColor = isSelected ? UIColor.blue01.cgColor : UIColor.blue02.cgColor

    }
}
