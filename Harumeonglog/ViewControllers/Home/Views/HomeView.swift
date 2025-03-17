import UIKit
import SnapKit
import FSCalendar

protocol HomeViewDelegate: AnyObject {
    func showMonthYearPicker() // 📌 년/월 선택 모달 표시
    func changeMonth(to date: Date) // 📌 선택한 월로 캘린더 이동
}

class HomeView: UIView, FSCalendarDelegate, FSCalendarDataSource {
    
    weak var delegate: HomeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bg
        addComponents()
        // 초기 선택을 오늘 날짜로
        DispatchQueue.main.async {
            self.calendarView.select(Date())
        }
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "alarm_button"), for: .normal)
        button.isUserInteractionEnabled = true // ✅ 터치 가능하도록 설정
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dog1")
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "카이"
        label.font = UIFont(name: K.FontName.pretendard_regular, size: 20)
        label.textColor = .gray00
        return label
    }()
    
    lazy var genderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gender_boy")
        return imageView
    }()
    
    lazy var addScheduleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular), forImageIn: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue01
        button.layer.cornerRadius = 30
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var birthdayIconLabel: UILabel = {
        let label = UILabel()
        label.text = "🎂"
        label.font = K.Font.description
        return label
    }()
    
    lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "2005.01.01"
        label.font = K.Font.description
        label.textColor = .gray01
        return label
    }()
    
    lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.placeholderType = .none
        calendar.appearance.selectionColor = .blue01
        calendar.appearance.titleDefaultColor = .gray00
        calendar.appearance.titleSelectionColor = .white
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 오늘 날짜 스타일 변경
        calendar.appearance.todayColor = .blue02  // 배경색 제거
        calendar.appearance.todaySelectionColor = .blue01
        calendar.appearance.titleTodayColor = .gray00  // 오늘 날짜 글자색 빨간색
        
        calendar.appearance.weekdayTextColor = .gray00
        calendar.appearance.weekdayFont = UIFont(name: K.FontName.pretendard_medium, size: 12)
        calendar.headerHeight = 50
        calendar.calendarHeaderView.isHidden = true  // 기본 헤더 숨김
        return calendar
    }()
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, dropdownIcon])
        dropdownIcon.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = true // 터치 가능하도록 설정
        return stackView
    }()
    
    // 📌 **사용자 정의 헤더 (년/월 표시 + 드롭다운 버튼)**
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: K.FontName.pretendard_medium, size: 16)
        label.textColor = .gray00
        label.text = getCurrentMonthString(for: calendarView.currentPage)
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()

    lazy var dropdownIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .gray00
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
                imageView.addGestureRecognizer(tapGesture)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true // 터치 가능하도록 설정

        return imageView
    }()
    

    private func addComponents() {
        super.layoutSubviews()
        addSubview(alarmButton)
        addSubview(addScheduleButton)
        addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(birthdayIconLabel)
        addSubview(birthdayLabel)
        addSubview(genderImageView)
        addSubview(calendarView)

        addSubview(headerStackView)
        
        alarmButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(81)
            make.trailing.equalToSuperview().inset(30)
            make.width.height.equalTo(30)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(132)
            make.leading.equalToSuperview().offset(30)
            make.width.height.equalTo(70)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(18)
            make.leading.equalTo(profileImageView.snp.trailing).offset(18)
            make.height.equalTo(20)
        }
        
        genderImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.height.width.equalTo(16)
        }
        
        birthdayIconLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.height.equalTo(18)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.leading.equalTo(birthdayIconLabel.snp.trailing).offset(3)
            make.centerY.equalTo(birthdayIconLabel)
            make.height.equalTo(18)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(330)
        }
        
        addScheduleButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(60)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(calendarView.snp.leading).offset(15) //왼쪽 정렬
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        superview?.bringSubviewToFront(addScheduleButton)
        superview?.bringSubviewToFront(alarmButton)        
    }

    private func getCurrentMonthString(for date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 MM월"
        return formatter.string(from: date)
    }

        // 📌 **선택한 년/월로 캘린더 이동**
    private func changeMonth(to date: Date) {
        calendarView.setCurrentPage(date, animated: true)
        headerLabel.text = getCurrentMonthString(for: date)
    }

    // 📌 **헤더 텍스트 업데이트 (HomeViewController에서 호출)**
        func updateHeaderLabel() {
            headerLabel.text = getCurrentMonthString(for: calendarView.currentPage)
        }
    @objc private func headerTapped() {
            delegate?.showMonthYearPicker()
        }
    
    func setCalendarTo(date: Date) {
            calendarView.setCurrentPage(date, animated: true)
            updateHeaderLabel()
        }
}
