import UIKit
import SnapKit
import FSCalendar

protocol HomeViewDelegate: AnyObject {
    func changeMonth(to date: Date) // 선택한 월로 캘린더 이동
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
        calendarView.scope = .week
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var appLogoLabel : UILabel = {
        let label = UILabel()
        label.textColor = .brown02
        label.layer.cornerRadius = 15
        label.backgroundColor = .brown00
        label.font = .body
        label.clipsToBounds = true
        return label
    }()
    
    lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "alarm_button"), for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dog1"), for: .normal) // 기본 이미지 설정
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "카이"
        label.font = .headline
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
        label.font = .description
        return label
    }()
    
    lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "2005.01.01"
        label.font = .description
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
        calendar.appearance.todayColor = .blue02
        calendar.appearance.todaySelectionColor = .blue01
        calendar.appearance.titleTodayColor = .gray00
        
        calendar.appearance.weekdayTextColor = .gray00
        calendar.appearance.weekdayFont = .description
        calendar.scope = .week
        calendar.setScope(.week, animated: false)
        calendar.calendarHeaderView.isHidden = true  // 기본 헤더 숨김
        
        return calendar
    }()
    
    var calendarHeightConstraint: Constraint?
    
    //캘린더 height 맞추기
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint?.update(offset: bounds.height)

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
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
    
    // 사용자 정의 헤더 (년/월 표시 + 드롭다운 버튼)**
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: FontName.pretendard_medium.rawValue, size: 16)
        label.textColor = .gray00
        label.text = "" // 초기 텍스트 설정을 빈 문자열로 둡니다.
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var dropdownIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .gray00
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true // 터치 가능하도록 설정
        return imageView
    }()
    
    lazy var scheduleModalView : ScheduleModalView = {
        let view = ScheduleModalView()
        view.backgroundColor = .white
        view.isHidden = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.delegate = self.delegate as? ScheduleModalViewDelegate
        return view
    }()
    
    private func addComponents() {
        addSubview(appLogoLabel)
        addSubview(nicknameLabel)
        addSubview(birthdayIconLabel)
        addSubview(birthdayLabel)
        addSubview(genderImageView)
        addSubview(calendarView)
        addSubview(headerStackView)
        addSubview(scheduleModalView)
        addSubview(profileButton)
        addSubview(alarmButton)
        addSubview(addScheduleButton)
        
        appLogoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.trailing.equalToSuperview().inset(30)
            make.width.height.equalTo(30)
        }
        
        profileButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(132)
            make.leading.equalToSuperview().offset(30)
            make.width.height.equalTo(70)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.top).offset(18)
            make.leading.equalTo(profileButton.snp.trailing).offset(18)
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
            make.top.equalTo(profileButton.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(15)
            calendarHeightConstraint = make.height.equalTo(370).constraint
        }
        
        addScheduleButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(60)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(calendarView.snp.leading).offset(15) //왼쪽 정렬
            make.top.equalTo(profileButton.snp.bottom).offset(20)
        }
        
        scheduleModalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(calendarView.snp.bottom).offset(10)
        }
        //self.bringSubviewToFront(headerStackView)
    }
}
