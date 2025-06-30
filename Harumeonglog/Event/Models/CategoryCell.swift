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
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
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
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.layer.masksToBounds = true
    }

    func configure(with text: String, isSelected: Bool) {
        titleLabel.text = text
        contentView.backgroundColor = isSelected ? .brown01 : .white
        titleLabel.textColor = isSelected ? .white : .gray00
        contentView.layer.borderColor = isSelected ? UIColor.brown01.cgColor : UIColor.gray03.cgColor
        contentView.layer.borderWidth = 1

        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = isSelected ? 0.1 : 0
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
    }
}
