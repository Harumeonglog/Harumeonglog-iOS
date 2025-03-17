//
//  HomeViewController.swift
//  Harumeonglog
//

import UIKit
import FSCalendar
import SnapKit

class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, HomeViewDelegate {

    private lazy var homeView: HomeView = {
        let view = HomeView()
        view.calendarView.delegate = self
        view.calendarView.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var scheduleModalVC: ScheduleModalViewController = {
        let vc = ScheduleModalViewController()
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        setupScheduleModal()
        
        // 캘린더를 오늘 날짜로 초기화
        homeView.calendarView.setCurrentPage(Date(), animated: false)
        homeView.calendarView.select(Date())
        
        // 버튼 액션 추가
        homeView.addScheduleButton.addTarget(self, action: #selector(addScheduleButtonTapped), for: .touchUpInside)
        homeView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
    }

    private func setupScheduleModal() {
        addChild(scheduleModalVC)
        view.addSubview(scheduleModalVC.view)
        scheduleModalVC.didMove(toParent: self)
        
        scheduleModalVC.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(homeView.calendarView.snp.bottom).offset(20) // ✅ 캘린더 아래 20pt 유지
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom) // ✅ 네비게이션 바 위 고정
            make.height.equalTo(300) // ✅ 기본 높이 설정
        }
        
        // ✅ 버튼을 모달보다 위로 올리기
        view.bringSubviewToFront(homeView.addScheduleButton)
        view.bringSubviewToFront(homeView.alarmButton)
    }

    // 📌 **캘린더 페이지가 변경될 때 헤더 업데이트**
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        homeView.updateHeaderLabel()
    }
    
    // 📌 **Add Schedule 화면 이동**
    @objc func addScheduleButtonTapped() {
        let addVC = AddScheduleViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }

    // 📌 **알람 화면 이동**
    @objc func alarmButtonTapped() {
        let alarmVC = AlarmViewController()
        self.navigationController?.pushViewController(alarmVC, animated: true)
    }

    func showMonthYearPicker() {
        let pickerVC = UIViewController()
        pickerVC.preferredContentSize = CGSize(width: view.frame.width, height: 250) // ✅ 크기 지정

        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        // ✅ 현재 캘린더의 년/월을 기본값으로 설정
        let currentDate = homeView.calendarView.currentPage
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)

        let selectedYear = components.year ?? Calendar.current.component(.year, from: Date())
        let selectedMonth = components.month ?? Calendar.current.component(.month, from: Date())

        if let yearIndex = years.firstIndex(of: selectedYear), let monthIndex = months.firstIndex(of: selectedMonth) {
            pickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            pickerView.selectRow(monthIndex, inComponent: 1, animated: false)
        }

        pickerVC.view.addSubview(pickerView)

        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.setValue(pickerVC, forKey: "contentViewController")

        let confirmAction = UIAlertAction(title: "선택", style: .default) { _ in
            let selectedYear = self.years[pickerView.selectedRow(inComponent: 0)]
            let selectedMonth = self.months[pickerView.selectedRow(inComponent: 1)]

            // ✅ 선택한 년/월로 캘린더 이동
            self.changeMonth(toYear: selectedYear, month: selectedMonth)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    // 📌 **선택한 년/월로 캘린더 이동**
    func changeMonth(to date: Date) {
        homeView.setCalendarTo(date: date)
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    var years: [Int] {
        return Array(2000...2030)
    }

    var months: [Int] {
        return Array(1...12)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // "년"과 "월" 두 개의 컴포넌트
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? years.count : months.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(years[row])년" : "\(months[row])월"
    }

    // ✅ 선택한 년/월로 캘린더 이동
    func changeMonth(toYear year: Int, month: Int) {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        if let date = calendar.date(from: components) {
            homeView.setCalendarTo(date: date)
        }
    }
}
