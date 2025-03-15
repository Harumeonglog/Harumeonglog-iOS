//
//  AddScheduleView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit
import SnapKit


protocol AddScheduleViewDelegate: AnyObject {
    func categoryDidSelect(_ category: CategoryType)
}

class AddScheduleView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: AddScheduleViewDelegate?  // Delegate 선언

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bg
        addComponents()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //제목 textfield
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "일정 제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray02]
        )
        textField.font = K.Font.body
        textField.textColor = .gray02
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown01.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    //일정 정보 담는 view
    lazy var scheduleInfoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.brown01.cgColor
        view.layer.borderWidth = 1.0
        view.backgroundColor = .white
        return view
    }()
    
    // ✅ 요일 선택 버튼들 (월~일)
    lazy var weekButtons: [UIButton] = {
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        return days.map { day in
            let button = UIButton(type: .system)
            button.setTitle(day, for: .normal)
            button.setTitleColor(.brown01, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.brown01.cgColor
            button.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
            return button
        }
    }()
        
        // ✅ 시간 선택 버튼
    lazy var timeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시간 선택 >", for: .normal)
        button.setTitleColor(.brown01, for: .normal)

        return button
    }()

        // ✅ 알람 설정 버튼
    lazy var alarmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("10분 전 팝업 >", for: .normal)
        button.setTitleColor(.brown01, for: .normal)

        return button
    }()
    
    //카테고리 선택 버튼
    lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.brown01.cgColor
        button.layer.cornerRadius = 15
        
        button.setTitle("카테고리 선택", for: .normal)
        button.setTitleColor(.gray02, for: .normal)
        button.titleLabel?.font = K.Font.body
        
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        let iconImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        iconImageView.tintColor = .gray00
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(iconImageView)

        // 아이콘 위치 설정 (버튼의 오른쪽 끝에서 25px 떨어지도록 고정)
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -25),
            iconImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18)
        ])

        button.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        return button
    }()
    
    //카테고리 드롭다운 리스트
    lazy var dropdownTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.brown01.cgColor
        tableView.layer.cornerRadius = 15
        return tableView
    }()

    private let categories: [CategoryType] = [.bath, .walk, .medicine, .checkup, .other]

    private func addComponents() {
        self.addSubview(titleTextField)
        self.addSubview(scheduleInfoView)
        self.addSubview(categoryButton)
        self.addSubview(dropdownTableView)
        
        let weekStack = UIStackView(arrangedSubviews: weekButtons)
                weekStack.axis = .horizontal
                weekStack.spacing = 8
                weekStack.distribution = .fillEqually
                
                let timeStack = UIStackView(arrangedSubviews: [UIImageView(image: UIImage(systemName: "clock")), timeButton])
                timeStack.axis = .horizontal
                timeStack.spacing = 8
                
                let alarmStack = UIStackView(arrangedSubviews: [UIImageView(image: UIImage(systemName: "bell")), alarmButton])
                alarmStack.axis = .horizontal
                alarmStack.spacing = 8

                let mainStack = UIStackView(arrangedSubviews: [timeStack, weekStack, alarmStack])
                mainStack.axis = .vertical
                mainStack.spacing = 12
        
        scheduleInfoView.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.height.equalTo(40)
            make.width.equalTo(362)
            make.centerX.equalToSuperview()
        }
        
        scheduleInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.width.equalTo(362)
            make.height.equalTo(160)
            make.centerX.equalToSuperview()
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(scheduleInfoView.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(362)
            make.centerX.equalToSuperview()
        }
        
        dropdownTableView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(5)
            make.width.equalTo(362)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func toggleDropdown() {
        dropdownTableView.isHidden.toggle()
    }

    // UITableView DataSource & Delegate
    //테이블뷰 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    //셀 구성하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell") ?? UITableViewCell(style: .default, reuseIdentifier: "DropdownCell")
        cell.textLabel?.text = categories[indexPath.row].rawValue
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = K.Font.body
        cell.textLabel?.textColor = UIColor.gray02


        return cell
    }
    //셀 선택시 동작 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
                cell.backgroundColor = .white  // 선택된 셀의 배경색을 하얀색으로 유지
            }

        let selectedCategory = categories[indexPath.row]
        categoryButton.setTitle("\(selectedCategory.rawValue)", for: .normal)
        categoryButton.setTitleColor(.gray00, for: .normal)
        
        dropdownTableView.isHidden = true
        delegate?.categoryDidSelect(selectedCategory)
    }
}
