// HomeViewController.swift
// Harumeonglog

import UIKit
import FSCalendar
import SnapKit

class HomeViewController: UIViewController, HomeViewDelegate, ScheduleModalViewDelegate {

    private lazy var homeView: HomeView = {
        let view = HomeView()
        return view
    }()

    //더미데이터
    private var allSchedules: [Schedule] = [
        Schedule(category: "건강", title: "병원 가기", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 24))!),
        Schedule(category: "산책", title: "공원 산책", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 31))!),
        Schedule(category: "산책", title: "공원 산책", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 31))!),
        Schedule(category: "산책", title: "공원 산책", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 31))!),
        Schedule(category: "산책", title: "공원 산책", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 31))!),
        Schedule(category: "기타", title: "친구 만나기", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 27))!),
        Schedule(category: "위생", title: "손톱 깎기", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 27))!)
    ]

    private var filteredSchedules: [Schedule] = []
    private var scheduleDates : [Date] = [] //일정 있는 날짜들

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        homeView.calendarView.delegate = self
        homeView.calendarView.dataSource = self
        homeView.scheduleModalView.delegate = self

        // 캘린더를 오늘 날짜로 초기화
        homeView.calendarView.setCurrentPage(Date(), animated: false)
        homeView.calendarView.select(Date())

        // 버튼 액션 추가
        homeView.addScheduleButton.addTarget(self, action: #selector(addScheduleButtonTapped), for: .touchUpInside)
        homeView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)

        updateScheduleList()
        updateScheduleDates()
    }

    // MARK: - Schedule 업데이트
    private func updateScheduleList(category: String? = "전체") {
        if category == "전체" {
            filteredSchedules = allSchedules
        } else {
            filteredSchedules = allSchedules.filter { $0.category == category }
        }

        DispatchQueue.main.async {
            self.homeView.scheduleModalView.schedules = self.filteredSchedules.map { $0.title }
        }
    }
    
    private func updateScheduleDates() {
        scheduleDates = Array(Set(allSchedules.map { $0.date }))
    }
    
    // MARK: - Actions
    func didSelectCategory(_ category: String?) {
        updateScheduleList(category: category)
    }

    @objc func addScheduleButtonTapped() {
        let addVC = AddScheduleViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }

    @objc func alarmButtonTapped() {
        let notificationVC = NotiViewController()
        notificationVC.modalPresentationStyle = .overFullScreen
        present(notificationVC, animated: false)
    }
    
    @objc private func headerTapped() {
        showMonthYearPicker()
    }
}

// MARK: - FSCalendarDelegate & Appearance
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        homeView.updateHeaderLabel()
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        homeView.calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //날짜 아래에 점찍기
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // 일정이 있는 날짜에만 1 반환해서 점 표시
        return scheduleDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [.blue01]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 1)
    }
    
    //날짜 선택시 해당 일정 목록 보여주기
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        updateScheduleList(for: date)
    }
    
    fileprivate func updateScheduleList(for date: Date) {
        let filtered = allSchedules.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
        homeView.scheduleModalView.schedules = filtered.map { $0.title }
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
        homeView.setCalendarTo(date: date)
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
            homeView.setCalendarTo(date: date)
        }
    }
}
