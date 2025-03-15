import UIKit
import SnapKit
import FSCalendar

class HomeView: UIView, FSCalendarDelegate, FSCalendarDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bg
        addComponents()
        // 초기 선택을 오늘 날짜로
        DispatchQueue.main.async {
            self.calendarView.select(Date())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "alarm_button"), for: .normal)
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
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = K.Font.title
        button.backgroundColor = .blue01
        button.layer.cornerRadius = 25
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
        calendar.appearance.headerMinimumDissolvedAlpha = 0
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMonthYearPicker))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()

    lazy var dropdownIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .gray00
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMonthYearPicker))
                imageView.addGestureRecognizer(tapGesture)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    

    private func addComponents() {
        addSubview(alarmButton)
        addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(addScheduleButton)
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
            make.top.equalToSuperview().offset(680)
            make.trailing.equalToSuperview().inset(30)
            make.width.height.equalTo(50)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(calendarView.snp.leading).offset(15) //왼쪽 정렬
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        // ✅ 버튼을 가장 위로 가져오기
        bringSubviewToFront(addScheduleButton)
        addScheduleButton.layer.zPosition = 1
        
    }

    // 📌 **현재 월을 "YYYY년 MM월" 형식으로 반환**
        private func getCurrentMonthString(for date: Date = Date()) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY년 MM월"
            return formatter.string(from: date)
        }

        // 📌 **년/월 선택 ActionSheet 표시**
    @objc private func showMonthYearPicker() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .date
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.locale = Locale(identifier: "ko_KR")
        
        let currentDate = calendarView.currentPage
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        components.day = 1 // 날짜는 1일로 설정
        
        if let selectedDate = calendar.date(from: components) {
            pickerView.setDate(selectedDate, animated: false)
        }
        
        alertController.view.addSubview(pickerView)
        
        pickerView.snp.makeConstraints { make in
            make.centerX.equalTo(alertController.view)
            make.top.equalTo(alertController.view).offset(10)
            make.width.equalTo(alertController.view).multipliedBy(0.9)
        }
        
        let confirmAction = UIAlertAction(title: "선택", style: .default) { _ in
            self.changeMonth(to: pickerView.date)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        if let topViewController = getTopViewController() {
            topViewController.present(alertController, animated: true, completion: nil)
        }
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
    
        // 📌 **현재 가장 상단의 ViewController 찾기 (iOS 15 이상)**
    private func getTopViewController() -> UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
           let rootViewController = keyWindow.rootViewController {
            
            var topController: UIViewController = rootViewController
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
