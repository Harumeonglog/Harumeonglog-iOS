//
//  AddEventView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit
import SnapKit

//사용자가 버튼 눌렀을때 이벤트 처리할 수 있게
protocol AddEventViewDelegate: AnyObject {
    func categoryDidSelect(_ category: CategoryType)
    func dateButtonTapped()
    func timeButtonTapped()
    func weekdayTapped(_ weekday: String, isSelected: Bool)
}

class AddEventView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: AddEventViewDelegate?  // Delegate 선언

    var isEditable: Bool = true {
        didSet {
            titleTextField.isUserInteractionEnabled = isEditable
            dateButton.isUserInteractionEnabled = isEditable
            weekButtons.forEach { $0.isUserInteractionEnabled = isEditable }
            categoryButton.isUserInteractionEnabled = isEditable
        }
    }
    
    // 선택된 카테고리를 저장하는 프로퍼티
    public private(set) var selectedCategory: CategoryType?
    
    public var categoryInputView: UIView?
    
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
    lazy var EventInfoView: UIView = {
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
    
    
    //  요일 선택 버튼들 (월~일)
    lazy var weekButtons: [UIButton] = {
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        return days.map { day in
            let button = UIButton(type: .system)
            button.setTitle(day, for: .normal)
            button.accessibilityIdentifier = day
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
            iconImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20),
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
    
    // 스크롤뷰 추가
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    // 스크롤뷰 내부 콘텐츠 뷰
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var deleteEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .body
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -40)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 20)
        return button
    }()

    private let categories: [CategoryType] = [.bath, .walk, .medicine, .checkup, .other]

    private func addComponents() {
        
        // 스크롤뷰 구조 설정
        self.addSubview(scrollView)
        self.addSubview(deleteEventButton)
        
        scrollView.addSubview(contentView)
        
        // 콘텐츠 뷰에 요소들 추가
        contentView.addSubview(titleTextField)
        contentView.addSubview(EventInfoView)
        contentView.addSubview(categoryButton)
        contentView.addSubview(dropdownTableView)
        
        self.addSubview(navigationBar)
        
        EventInfoView.addSubview(timeIcon)
        EventInfoView.addSubview(repeatIcon)
            
        EventInfoView.addSubview(dateButton)
        EventInfoView.addSubview(timeButton)
        
        // weekButtons(요일 선택 버튼) 추가
        weekButtons.forEach { EventInfoView.addSubview($0) }
        
        // 네비게이션 바는 스크롤뷰 밖에 고정
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        // 스크롤뷰 설정
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(deleteEventButton.snp.top).offset(-20)
        }
        
        // 콘텐츠 뷰 설정
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        [timeIcon, repeatIcon].forEach { icon in
            icon.snp.makeConstraints { make in
                make.width.height.equalTo(22)
            }
        }
        
        timeIcon.snp.makeConstraints { make in
            make.leading.equalTo(EventInfoView.snp.leading).offset(20)
            make.top.equalToSuperview().offset(20)
        }
            
        repeatIcon.snp.makeConstraints { make in
            make.leading.equalTo(EventInfoView.snp.leading).offset(20)
            make.top.equalTo(timeIcon.snp.bottom).offset(28)
        }
            
            //버튼 크기 및 위치 설정
        dateButton.snp.makeConstraints { make in
            make.leading.equalTo(timeIcon.snp.trailing).offset(12)
            make.centerY.equalTo(timeIcon)
        }
        
        timeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(timeIcon)
        }
            
        // 요일 선택 버튼(weekButtons) 가로 정렬
        var previousButton: UIButton?
        for button in weekButtons {
            button.snp.makeConstraints { make in
                if let prev = previousButton {
                    make.leading.equalTo(prev.snp.trailing).offset(10) // 각 버튼 사이 8pt 간격
                } else {
                    make.leading.equalTo(repeatIcon.snp.trailing).offset(12) // 첫 번째 버튼은 repeatIcon에서 12pt
                }
                make.centerY.equalTo(repeatIcon.snp.centerY)
                make.width.height.equalTo(30) // 모든 버튼 크기 동일
            }
            previousButton = button
        }
            
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(45)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        EventInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(EventInfoView.snp.bottom).offset(15)
            make.height.equalTo(45)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        dropdownTableView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        // 삭제 버튼을 화면 하단에 고정
        deleteEventButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(20)
        }

        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        weekButtons.forEach { $0.addTarget(self, action: #selector(weekButtonTapped(_:)), for: .touchUpInside) }
    }

    @objc private func toggleDropdown() {
        dropdownTableView.isHidden.toggle()
    }

    @objc private func dateButtonTapped() {
        delegate?.dateButtonTapped()
    }

    @objc private func weekButtonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        let isSelected = sender.backgroundColor != .brown01
        delegate?.weekdayTapped(title, isSelected: isSelected)
    }

    func updateCategoryInputView(for category: CategoryType) {
        //이전 뷰 제거
        print("[AddEventView] 기존 categoryInputView 제거 시도")
        if let existingView = categoryInputView {
            existingView.removeFromSuperview()
            categoryInputView = nil
        }

        // 새로운 카테고리 뷰 생성 및 명시적 할당
        let newView: UIView
        switch category {
        case .bath:
            newView = UIView() 
        case .walk:
            newView = WalkView()
        case .medicine:
            newView = MedicineView()
        case .checkup:
            newView = CheckupView()
        case .other:
            newView = OtherView()
        }

        print("[AddEventView] 새로운 카테고리 \(category) 뷰 생성 완료")

        // 새 뷰를 contentView에 추가 (드롭다운 아래에 위치시키되, 드롭다운은 항상 버튼 바로 아래 떠야 함)
        contentView.insertSubview(newView, belowSubview: dropdownTableView)
        newView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview().inset(20) // 콘텐츠 뷰의 하단에 고정
        }
        // 드롭다운은 항상 버튼 바로 아래에 뜨도록 계층과 zPosition 보정
        contentView.bringSubviewToFront(dropdownTableView)
        dropdownTableView.layer.zPosition = 999
        
        // 뷰 참조 갱신
        self.categoryInputView = newView
        newView.isHidden = false
        
        print("[AddEventView] 카테고리 뷰 레이아웃 설정 완료")
        print("새로운 카테고리 뷰 추가됨: \(category)")
        
        // 레이아웃 즉시 적용
        self.layoutIfNeeded()
        print("[AddEventView] 카테고리 뷰 적용 완료")
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
        self.selectedCategory = selectedCategory
        
        // 카테고리 버튼 상태 업데이트
        categoryButton.setTitle("\(selectedCategory.rawValue)", for: .normal)
        categoryButton.setTitleColor(.gray00, for: .normal)
        
        // 드롭다운 숨기기
        dropdownTableView.isHidden = true
        
        print("카테고리 선택됨: \(selectedCategory.rawValue)")
        delegate?.categoryDidSelect(selectedCategory)
    }
    
}
