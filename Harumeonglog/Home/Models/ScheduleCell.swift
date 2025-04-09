//
//  ScheduleCell.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/15/25.
//

import UIKit
import SnapKit

class ScheduleCell: UITableViewCell {
    
    static let identifier = "ScheduleCell"
    
    private let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.brown02.cgColor
        view.layer.masksToBounds = true
        return view
    }()

    public let checkmarkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .brown01
        return imageView
    }()

    private let scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontName.pretendard_regular.rawValue, size: 16)
        label.textColor = .gray00
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(checkmarkIcon)
        containerView.addSubview(scheduleLabel)

        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }

        checkmarkIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        scheduleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(checkmarkIcon.snp.leading).offset(-10)
        }
    }
    func configure(schedule: String, isChecked: Bool) {
        scheduleLabel.text = schedule
        let iconName = isChecked ? "checkmark.circle.fill" : "checkmark.circle"
        checkmarkIcon.image = UIImage(systemName: iconName)
    }
}

struct Schedule {
    let category: String
    let title : String
    let date: Date
}
