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
    
    public lazy var navigationBar = CustomNavigationBar()

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
        textField.font = .body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.brown02.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    // 날짜, 알림, 반복 담는 뷰
    lazy var scheduleInfoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.brown02.cgColor
        view.layer.borderWidth = 1.0
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var timeIcon : UIImageView = {
        let image = UIImageView(image: UIImage(named: "time"))
        image.contentMode = .scaleAspectFit // 비율 유지
        image.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 적용
        return image
    }()
    
    private lazy var repeatIcon : UIImageView = {
        let image = UIImageView(image: UIImage(named: "repeat"))
        image.contentMode = .scaleAspectFit // 비율 유지
        image.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 적용
        return image
    }()
    
    private lazy var alarmIcon : UIImageView = {
        let image = UIImageView(image: UIImage(named: "alarm"))
        image.contentMode = .scaleAspectFit // 비율 유지
        image.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 적용
        return image
    }()
    
    
    //  요일 선택 버튼들 (월~일)
    lazy var weekButtons: [UIButton] = {
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        return days.map { day in
            let button = UIButton(type: .system)
            button.setTitle(day, for: .normal)
            button.titleLabel?.font = .description
            button.setTitleColor(.gray00, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.brown02.cgColor
            button.snp.makeConstraints { make in
                make.width.height.equalTo(30)
            }
            return button
        }
    }()
        
    // 시간 선택 버튼
    lazy var dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .body
        button.setTitleColor(.gray00, for: .normal)
        return button
    }()
    
    lazy var timeButton : UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .body
        button.setTitleColor(.gray00, for: .normal)
        return button
    }()

    // 알람 설정 버튼
    lazy var alarmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("10분 전 팝업", for: .normal)
        button.setTitleColor(.gray00, for: .normal)
        button.titleLabel?.font = .body
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .regular), forImageIn: .normal)

        button.tintColor = .gray00
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    //카테고리 선택 버튼
    lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.brown02.cgColor
        button.layer.cornerRadius = 15
        
        button.setTitle("카테고리 선택", for: .normal)
        button.setTitleColor(.gray02, for: .normal)
        button.titleLabel?.font = .body
        
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)

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
        tableView.layer.borderColor = UIColor.brown02.cgColor
        tableView.layer.cornerRadius = 15
        return tableView
    }()

    private let categories: [CategoryType] = [.bath, .walk, .medicine, .checkup, .other]

    private func addComponents() {
        self.addSubview(titleTextField)
        self.addSubview(scheduleInfoView)
        self.addSubview(categoryButton)
        self.addSubview(dropdownTableView)
        self.addSubview(navigationBar)
        
        scheduleInfoView.addSubview(timeIcon)
        scheduleInfoView.addSubview(repeatIcon)
        scheduleInfoView.addSubview(alarmIcon)
            
        scheduleInfoView.addSubview(dateButton)
        scheduleInfoView.addSubview(alarmButton)
        scheduleInfoView.addSubview(timeButton)
        
        // weekButtons(요일 선택 버튼) 추가
        weekButtons.forEach { scheduleInfoView.addSubview($0) }
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        [timeIcon, repeatIcon, alarmIcon].forEach { icon in
            icon.snp.makeConstraints { make in
                make.width.height.equalTo(22)
            }
        }
        
        timeIcon.snp.makeConstraints { make in
            make.leading.equalTo(scheduleInfoView.snp.leading).offset(30)  // scheduleInfoView의 leading에서 30pt
            make.top.equalToSuperview().offset(20)  // 상단에서 20pt
        }
            
        repeatIcon.snp.makeConstraints { make in
            make.leading.equalTo(scheduleInfoView.snp.leading).offset(30)
            make.top.equalTo(timeIcon.snp.bottom).offset(28)  // 요소 간 간격 40pt
        }
            
        alarmIcon.snp.makeConstraints { make in
            make.leading.equalTo(scheduleInfoView.snp.leading).offset(30)
            make.top.equalTo(repeatIcon.snp.bottom).offset(28)  // 요소 간 간격 40pt
        }
            
            //버튼 크기 및 위치 설정
        dateButton.snp.makeConstraints { make in
            make.leading.equalTo(timeIcon.snp.trailing).offset(15)
            make.centerY.equalTo(timeIcon)
        }
        
        timeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalTo(timeIcon)
        }
            
        // 요일 선택 버튼(weekButtons) 가로 정렬
        var previousButton: UIButton?
        for button in weekButtons {
            button.snp.makeConstraints { make in
                if let prev = previousButton {
                    make.leading.equalTo(prev.snp.trailing).offset(10) // 각 버튼 사이 8pt 간격
                } else {
                    make.leading.equalTo(repeatIcon.snp.trailing).offset(15) // 첫 번째 버튼은 repeatIcon에서 15pt 떨어짐
                }
                make.centerY.equalTo(repeatIcon.snp.centerY)
                make.width.height.equalTo(30) // 모든 버튼 크기 동일
            }
            previousButton = button
        }
            
        alarmButton.snp.makeConstraints { make in
            make.leading.equalTo(alarmIcon.snp.trailing).offset(15)
            make.centerY.equalTo(alarmIcon)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.height.equalTo(45)
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
            make.height.equalTo(45)
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
        cell.textLabel?.font = .body
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
