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
    
    lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "alarm_button"), for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var profileButton: UIButton = {
        let button = UIButton()
        // 기본 이미지 설정 - 모달과 동일한 스타일의 pawprint.fill
        button.setImage(createDefaultProfileImage(), for: .normal)
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    // 기본 프로필 이미지 생성 함수 (모달과 동일한 스타일)
    private func createDefaultProfileImage() -> UIImage? {
        let size = CGSize(width: 70, height: 70)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // 배경 색상 - 모달과 동일하게 systemGray5
            UIColor.systemGray5.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // 흰색으로 tint된 pawprint.fill 심볼 이미지 그리기
            let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
            if let symbolImage = UIImage(systemName: "pawprint.fill", withConfiguration: config)?
                .withTintColor(.white, renderingMode: .alwaysOriginal) {
                
                let symbolRect = CGRect(
                    x: (size.width - 40) / 2,
                    y: (size.height - 40) / 2,
                    width: 40,
                    height: 40
                )
                symbolImage.draw(in: symbolRect)
            }
        }
    }
    
    lazy var infoContainer = UIView().then { view in
    }
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지를 추가하세요"
        label.font = .headline
        label.textColor = .gray00
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    lazy var genderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gender_boy")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    lazy var addeventButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular), forImageIn: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue01
        button.layer.cornerRadius = 30
        button.isUserInteractionEnabled = true
        button.isHidden = false
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
    
    var eventView = EventView() // eventView 추가

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
    
    
    
    //MARK: constraint 잡기
    private func addComponents() {
        addSubview(infoContainer)
        infoContainer.addSubview(nicknameLabel)
        infoContainer.addSubview(genderImageView)
        infoContainer.addSubview(birthdayIconLabel)
        infoContainer.addSubview(birthdayLabel)
        addSubview(profileButton)
        addSubview(calendarView)
        addSubview(headerStackView)
        addSubview(alarmButton)
        addSubview(eventView)
        addSubview(addeventButton)
        alarmButton.snp.makeConstraints { make in
            // Align Y with profileButton (dog image)
            make.centerY.equalTo(profileButton)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(30)
        }
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(70)
        }
        
        infoContainer.snp.makeConstraints { make in
            make.centerY.equalTo(profileButton)
            make.leading.equalTo(profileButton.snp.trailing).offset(12)
            make.height.greaterThanOrEqualTo(50)
            make.width.equalTo(50)
        }
         
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        
        genderImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(4)
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
            make.top.equalTo(profileButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            calendarHeightConstraint = make.height.equalTo(370).constraint
        }
        
        eventView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        addeventButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(60)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(calendarView.snp.leading)
            make.top.equalTo(profileButton.snp.bottom).offset(20)
        }
        
        self.bringSubviewToFront(profileButton)
    }
}
