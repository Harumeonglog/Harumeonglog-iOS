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

    private let checkmarkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .blue01
        return imageView
    }()

    private let scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: K.FontName.pretendard_regular, size: 16)
        label.textColor = .gray00
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(checkmarkIcon)
        containerView.addSubview(scheduleLabel)

        // ✅ **컨테이너 뷰 크기 설정**
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(7)
        }

                // ✅ **체크박스 아이콘**
        checkmarkIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

                // ✅ **일정 제목 라벨**
        scheduleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(checkmarkIcon.snp.leading).offset(-10) // ✅ 체크박스와 간격 유지
        }
    }
    func configure(schedule: String, isChecked: Bool) {
        scheduleLabel.text = schedule
        checkmarkIcon.tintColor = isChecked ? .brown01 : .clear
    }
}
