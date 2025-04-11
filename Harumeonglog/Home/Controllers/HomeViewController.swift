import UIKit
import FSCalendar
import SnapKit

protocol ProfileSelectDelegate: AnyObject {
    func didSelectProfile(_ profile: Profile)
}

class HomeViewController: UIViewController, HomeViewDelegate {

    private lazy var homeView: HomeView = {
        let view = HomeView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        homeView.delegate = self
        homeView.calendarView.delegate = self
        homeView.calendarView.dataSource = self

        homeView.calendarView.setCurrentPage(Date(), animated: false)
        homeView.calendarView.select(Date())

        fetchPets()

        homeView.scheduleView.updateSchedules(for: Date())
        setupButtons()
        updateHeaderLabel()
    }
    
    private func fetchPets() {
        PetService.fetchPets(completion: { result in
            switch result {
            case .success(let response):
                switch response.result {
                case .result(let petResult):
                    let pets = petResult.pets
                    if let defaultPet = pets.first(where: { $0.petId == 1 }) {
                        print("선택된 반려견: \(defaultPet.name)")
                        self.homeView.nicknameLabel.text = defaultPet.name
                        self.homeView.profileButton.setImage(UIImage(named: defaultPet.mainImage ?? ""), for: .normal)
                        self.homeView.birthdayLabel.text = defaultPet.birth ?? ""
                    }
                case .message(let msg):
                    print("result 메시지: \(msg)")
                case .none:
                    print("result 없음")
                }
            case .failure(let error):
                debugPrint("반려동물 조회 실패: \(error)")
            }
        })
    }
    
                             
    // MARK: - 버튼 동작 함수들 모음
    private func setupButtons() {
        homeView.addScheduleButton.addTarget(self, action: #selector(addScheduleButtonTapped), for: .touchUpInside)
        homeView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        
        //헤더 누르면 년/월 선택
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        homeView.headerStackView.addGestureRecognizer(headerTap)
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCalendarSwipe(_:)))
        homeView.calendarView.addGestureRecognizer(swipeGesture)

        homeView.profileButton.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
    }

    @objc func addScheduleButtonTapped() {
        let addVC = AddScheduleViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }

    @objc func alarmButtonTapped() {
        let alarmVC = AlarmViewController()
        self.navigationController?.pushViewController(alarmVC, animated: true)
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

    private func updateHeaderLabel() {
        homeView.headerLabel.text = getCurrentMonthString(for: homeView.calendarView.currentPage)
    }

    private func setCalendarTo(date: Date) {
        homeView.calendarView.setCurrentPage(date, animated: true)
        updateHeaderLabel()
    }
}

// MARK: - FSCalendarDelegate & Appearance
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel()
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        homeView.calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 날짜 선택시 해당 일정 목록 보여주기
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        homeView.scheduleView.updateSchedules(for: date)
    }
}

// MARK: - HomeViewDelegate
extension HomeViewController {
    func showMonthYearPicker() {
        let pickerVC = UIViewController()
        pickerVC.preferredContentSize = CGSize(width: view.frame.width, height: 250)

        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        let currentDate = homeView.calendarView.currentPage
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)

        if let y = components.year, let m = components.month,
           let yi = years.firstIndex(of: y), let mi = months.firstIndex(of: m) {
            pickerView.selectRow(yi, inComponent: 0, animated: false)
            pickerView.selectRow(mi, inComponent: 1, animated: false)
        }

        pickerVC.view.addSubview(pickerView)
        pickerView.snp.makeConstraints { $0.edges.equalToSuperview() }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.setValue(pickerVC, forKey: "contentViewController")

        alertController.addAction(UIAlertAction(title: "선택", style: .default) { _ in
            let y = self.years[pickerView.selectedRow(inComponent: 0)]
            let m = self.months[pickerView.selectedRow(inComponent: 1)]
            self.changeMonth(toYear: y, month: m)
        })
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))

        present(alertController, animated: true)
    }

    func changeMonth(to date: Date) {
        setCalendarTo(date: date)
    }
}

// MARK: - UIPickerView
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    var years: [Int] { Array(2000...2030) }
    var months: [Int] { Array(1...12) }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? years.count : months.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        component == 0 ? "\(years[row])년" : "\(months[row])월"
    }

    func changeMonth(toYear year: Int, month: Int) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        if let date = Calendar.current.date(from: components) {
            setCalendarTo(date: date)
        }
    }
}

// MARK: - 프로필 선택
extension HomeViewController: ProfileSelectDelegate {

    // 프로필이 선택되었을 때 호출되는 메서드 - 생일, 이름 바뀌도록
    func didSelectProfile(_ profile: Profile) {
        // 선택된 프로필을 업데이트
        homeView.nicknameLabel.text = profile.name
        homeView.profileButton.setImage(UIImage(named: profile.imageName), for: .normal)
        homeView.birthdayLabel.text = profile.birthDate
    }

    @objc private func profileImageTapped() {
        let profileModalVC = ProfileSelectModalViewController()
        profileModalVC.modalPresentationStyle = .pageSheet
        profileModalVC.delegate = self
        self.present(profileModalVC, animated: true, completion: nil)
    }
}
