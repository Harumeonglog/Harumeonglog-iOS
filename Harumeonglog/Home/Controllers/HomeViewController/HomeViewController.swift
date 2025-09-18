//화면, 버튼, 뷰 연결

import UIKit
import Alamofire
import FSCalendar
import SnapKit

protocol ProfileSelectDelegate: AnyObject {
    func didSelectProfile(_ profile: Profile)
}

class HomeViewController: UIViewController, HomeViewDelegate {
    func changeMonth(to date: Date) {
        setCalendarTo(date: date)
    }
    

    let eventViewModel = HomeEventViewModel()
    let petViewModel = HomePetViewModel()

    private var hasLoadedEventDates = false
    private var hasLoadedSelectedDateEvents = false
    var selectedDate: Date = Date() // 선택된 날짜 저장 (internal로 변경)

    var markedDates: [Date] = []
    var markedDateStrings: Set<String> = []
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    lazy var homeView: HomeView = {
        let view = HomeView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        homeView.delegate = self
        homeView.calendarView.delegate = self
        homeView.calendarView.dataSource = self
        homeView.eventView.delegate = self
        
        homeView.calendarView.setCurrentPage(Date(), animated: false)
        homeView.calendarView.select(Date())
        applyWeekdayHeaderColors()
        
        fetchActivePets()
        
        setupButtons()
        updateHeaderLabel()
        
        // 키보드 숨김 처리 추가
        hideKeyboardWhenTappedAround()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        // 산책 종료/저장 후 서버에서 최신 이벤트 날짜 재조회
        NotificationCenter.default.addObserver(self, selector: #selector(handleWalkCompletedForCalendarRefresh), name: NSNotification.Name("WalkEnded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleWalkCompletedForCalendarRefresh), name: NSNotification.Name("WalkSaved"), object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasLoadedEventDates {
            fetchEventDatesForCurrentMonth()
            hasLoadedEventDates = true
        }
        if !hasLoadedSelectedDateEvents {
            loadEventsForSelectedDate()
            hasLoadedSelectedDateEvents = true
        }
    }
    
    //
    private func fetchActivePets() {
        // 먼저 현재 활성 펫 정보를 가져옴
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else { return }
        
        PetService.ActivePetInfo(token: token) { result in
            switch result {
            case .success(let response):
                if let activePetInfo = response.result {
                    // ActivePets에서 해당 펫의 역할 정보 가져오기
                    self.petViewModel.fetchActivePets { activePetsResult in
                        guard let activePets = activePetsResult else { return }
                        
                        // 현재 활성 펫과 일치하는 펫 찾기
                        if let currentPet = activePets.pets.first(where: { $0.petId == activePetInfo.petId }) {
                            DispatchQueue.main.async {
                                print("현재 활성 반려견: \(activePetInfo.name) (ID: \(activePetInfo.petId))")
                                self.homeView.nicknameLabel.text = activePetInfo.name
                                
                                // 생일 표시
                                self.homeView.birthdayLabel.text = activePetInfo.birth
                                // 성별 아이콘 표시
                                self.updateGenderIcon(activePetInfo.gender)
                                
                                // GUEST 역할인 경우 이벤트 추가 버튼 숨김
                                let role = currentPet.role
                                if role == "GUEST" {
                                    self.homeView.addeventButton.isHidden = true
                                } else {
                                    self.homeView.addeventButton.isHidden = false
                                }

                                // 이미지 로딩 개선
                                self.loadProfileImage(activePetInfo.mainImage ?? "")
                            }
                        } else {
                            // 활성 펫이지만 목록이 비어있거나 매칭 실패 -> 무펫 처리
                            DispatchQueue.main.async {
                                self.applyNoPetState()
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async { self.applyNoPetState() }
                }
            case .failure(let error):
                print("ActivePetInfo 조회 실패: \(error)")
                // 실패 시 기본 펫으로 fallback
                self.petViewModel.fetchActivePets { activePetsResult in
                    guard let activePets = activePetsResult else { DispatchQueue.main.async { self.applyNoPetState() }; return }
                    if let firstPet = activePets.pets.first {
                        DispatchQueue.main.async {
                            self.homeView.nicknameLabel.text = firstPet.name
                            self.homeView.birthdayLabel.text = "생일 정보 없음"
                            self.homeView.genderImageView.image = UIImage(named: "gender_boy")
                            
                            let role = firstPet.role
                            if role == "GUEST" {
                                self.homeView.addeventButton.isHidden = true
                                print("GUEST 역할이므로 이벤트 추가 버튼 숨김")
                            } else {
                                self.homeView.addeventButton.isHidden = false
                                print("\(role) 역할이므로 이벤트 추가 버튼 표시")
                            }
                            
                            self.loadProfileImage(firstPet.mainImage ?? "")
                        }
                    } else {
                        DispatchQueue.main.async { self.applyNoPetState() }
                    }
                }
            }
        }
    }

    private func applyNoPetState() {
        self.homeView.addeventButton.isHidden = true
        self.homeView.nicknameLabel.text = "강아지를 추가하세요"
        self.homeView.birthdayLabel.text = ""
        self.homeView.genderImageView.image = nil
    }
    
                             
    // MARK: - 버튼 동작 함수들 모음
    private func setupButtons() {
        homeView.addeventButton.addTarget(self, action: #selector(addeventButtonTapped), for: .touchUpInside)
        homeView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        
        //헤더 누르면 년/월 선택
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        homeView.headerStackView.addGestureRecognizer(headerTap)
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCalendarSwipe(_:)))
        homeView.calendarView.addGestureRecognizer(swipeGesture)

        homeView.profileButton.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
    }

    @objc func addeventButtonTapped() {
        // Prevent duplicate pushes
        if let top = self.navigationController?.topViewController, top is AddEventViewController { return }
        let addVC = AddEventViewController()
        addVC.selectedDate = selectedDate // 선택된 날짜 전달
        addVC.delegate = self // 델리게이트 설정
        addVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addVC, animated: true)
    }

    @objc func alarmButtonTapped() {
        let notificationVC = NotiViewController()
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc private func headerTapped() {
        print("헤더 탭 감지됨")
        showMonthYearPicker()
    }
    
    @objc private func handleCalendarSwipe(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: homeView.calendarView).y
        if gesture.state == .ended {
            if velocity < -300 {
                homeView.calendarView.setScope(.week, animated: true)
            } else if velocity > 300 {
                homeView.calendarView.setScope(.month, animated: true)
            }
        }
    }

    private func getCurrentMonthString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }

    func updateGenderIcon(_ genderString: String) {
        let normalized = genderString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .uppercased()
        let imageName: String
        if normalized == "MALE" || normalized == "M" || normalized == "MAN" || normalized == "BOY" {
            imageName = "gender_boy"
        } else if normalized == "FEMALE" || normalized == "F" || normalized == "WOMAN" || normalized == "GIRL" {
            imageName = "gender_girl"
        } else {
            // 알 수 없는 값인 경우 기본 boy
            imageName = "gender_boy"
        }
        self.homeView.genderImageView.image = UIImage(named: imageName)
    }

    func updateHeaderLabel() {
        homeView.headerLabel.text = getCurrentMonthString(for: homeView.calendarView.currentPage)
    }

    // 요일 헤더(일~토) 색상 적용: 일=red, 토=blue, 나머지=gray
    func applyWeekdayHeaderColors() {
        let labels = homeView.calendarView.calendarWeekdayView.weekdayLabels
        for label in labels {
            switch label.text {
            case "일":
                label.textColor = .red00
            case "토":
                label.textColor = .blue01
            default:
                label.textColor = .gray00
            }
        }
    }

    func fetchEventDatesForCurrentMonth(completion: (() -> Void)? = nil) {
        markedDateStrings = [] 

        let currentDate = homeView.calendarView.currentPage
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)

        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 없음")
            completion?()
            return
        }

        eventViewModel.fetchEventDates(year: year, month: month, token: token) { result in
            switch result {
            case .success(let response):
                if let dateStrings = response.result?.dates {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"

                    // 문자열 그대로 저장해서 비교 정확도 향상
                    self.markedDateStrings = Set(dateStrings)

                    let workItem = DispatchWorkItem {
                        self.homeView.calendarView.reloadData()
                        completion?()
                    }
                    DispatchQueue.main.async(execute: workItem)
                }
            case .failure(let error):
                print("이벤트 날짜 조회 실패: \(error)")
                completion?()
            }
        }
    }
    

    func setCalendarTo(date: Date) {
        homeView.calendarView.setCurrentPage(date, animated: true)
        updateHeaderLabel()
    }

    private func loadEventsForSelectedDate() {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else { return }
        let selectedCategoryKey = homeView.eventView.selectedCategory?.serverKey
        eventViewModel.fetchEventsByDate(selectedDate, token: token, category: selectedCategoryKey) { [weak self] result in
            switch result {
            case .success(let eventDates):
                DispatchQueue.main.async {
                    let eventCategory = selectedCategoryKey ?? "OTHER"
                    let mapped = eventDates.map { Event(id: $0.id, title: $0.title, category: eventCategory, done: $0.done) }
                    self?.homeView.eventView.updateEvents(mapped)
                }
            case .failure:
                break
            }
        }
    }
    
    
    // 프로필 이미지 로딩 메서드
    private func loadProfileImage(_ imageName: String) {
        // 기본 이미지 설정 - Settings와 동일한 defaultImage 사용
        let defaultImage = UIImage(named: "defaultImage")
        homeView.profileButton.setImage(defaultImage, for: .normal)
        
        // 유효한 이미지 URL인 경우에만 로딩 시도
        if !imageName.isEmpty && imageName != "string" && imageName != "null" {
            if let url = URL(string: imageName) {
                print("홈화면 프로필 이미지 로딩 시도: \(url)")
                
                // 이미지 캐싱을 위한 URLSession 설정
                let config = URLSessionConfiguration.default
                config.requestCachePolicy = .returnCacheDataElseLoad
                config.urlCache = URLCache.shared
                config.timeoutIntervalForRequest = 10 // 10초 타임아웃
                
                let session = URLSession(configuration: config)
                session.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print("홈화면 프로필 이미지 다운로드 실패: \(error)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("홈화면 프로필 이미지 HTTP 응답: \(httpResponse.statusCode)")
                        if httpResponse.statusCode != 200 {
                            print("홈화면 프로필 이미지 HTTP 오류: \(httpResponse.statusCode)")
                            return
                        }
                    }
                    
                    if let data = data, !data.isEmpty, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.homeView.profileButton.setImage(image, for: .normal)
                            print("홈화면 프로필 이미지 로딩 성공 - 크기: \(data.count) bytes")
                        }
                    } else {
                        print("홈화면 프로필 이미지 데이터 변환 실패 - 데이터 크기: \(data?.count ?? 0)")
                        // 실패 시 기본 이미지 유지
                    }
                }.resume()
            } else {
                print("홈화면 프로필 이미지 URL이 유효하지 않음: \(imageName)")
                // 유효하지 않은 URL 시 기본 이미지 유지
            }
        } else {
            print("홈화면 프로필 이미지 URL이 비어있거나 유효하지 않음: \(imageName)")
            // 빈 URL 시 기본 이미지 유지
        }
    }
}

// MARK: - EventViewDelegate
extension HomeViewController: EventViewDelegate {
    func didSelectEvent(_ event: Event) {
        // 이벤트 선택 시 편집 화면으로 이동
        let editVC = EditEventViewController(eventId: event.id)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func didSelectCategory(_ category: String) {
        // 카테고리 선택 시 로그 출력 (필요시 추가 로직 구현)
        print("카테고리 선택됨: \(category)")
    }
}

// MARK: - AddEventViewControllerDelegate
extension HomeViewController: AddEventViewControllerDelegate {
    func didAddEvent() {
        // 일정 추가 완료 후 실시간 동기화
        
        // 1. 이벤트 날짜 다시 로드 (캘린더 점 표시 업데이트)
        fetchEventDatesForCurrentMonth()
        
        // 2. 선택된 날짜의 이벤트 다시 로드 (현재 화면 업데이트)
        if let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty {
            eventViewModel.fetchEventsByDate(selectedDate, token: token) { result in
                switch result {
                case .success(let eventDates):
                    let workItem = DispatchWorkItem {
                        let mappedEvents = eventDates.map { eventDate in
                            // EventDate에는 category가 없으므로, 기본값 사용
                            return Event(id: eventDate.id, title: eventDate.title, category: "OTHER", done: eventDate.done)
                        }
                        self.homeView.eventView.updateEvents(mappedEvents)
                        print("일정 추가 후 선택된 날짜 이벤트 \(eventDates.count)건 갱신 완료")
                    }
                    DispatchQueue.main.async(execute: workItem)
                case .failure(let error):
                    print("일정 추가 후 이벤트 재조회 실패: \(error)")
                }
            }
        }
        
        // 3. 캘린더 UI 즉시 업데이트
        DispatchQueue.main.async {
            self.homeView.calendarView.reloadData()
        }
    }
}


// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 이벤트 목록 중 선택된 index의 eventId를 전달
        let editVC = EditEventViewController(eventId: indexPath.row + 1)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}

extension HomeViewController {
    @objc fileprivate func handleWalkCompletedForCalendarRefresh() {
        // 1) 월 단위 점표시 갱신
        fetchEventDatesForCurrentMonth() { [weak self] in
            // 2) 선택된 날짜의 이벤트 목록도 최신화
            self?.loadEventsForSelectedDate()
        }
    }
}
