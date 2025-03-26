//
//  HomeViewController2.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/26/25.
//
/*
import UIKit
import FSCalendar
import SnapKit

class HomeViewController2: UIViewController, FSCalendarDelegate, FSCalendarDataSource,HomeViewDelegate {

    private lazy var homeView: HomeView = {
        let view = HomeView()
        view.calendarView.delegate = self
        view.calendarView.dataSource = self
        view.delegate = self
        //view.scheduleModalView.delegate = self
        return view
    }()

    private var allSchedules: [(category: String, title: String)] = [
        ("위생", "목욕하기"),
        ("건강", "병원 가기"),
        ("산책", "공원 산책"),
        ("기타", "친구 만나기"),
        ("건강", "운동하기"),
        ("산책", "강아지랑 걷기"),
        ("위생", "손톱 깎기")
    ]

    private var filteredSchedules: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(homeView)
        view.backgroundColor = .white

        // 캘린더를 오늘 날짜로 초기화
        homeView.calendarView.setCurrentPage(Date(), animated: false)
        homeView.calendarView.select(Date())

        // 버튼 액션 추가
        //homeView.addScheduleButton.addTarget(self, action: #selector(addScheduleButtonTapped), for: .touchUpInside)
        //homeView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)

        updateScheduleList()
    }

    // MARK: - Schedule 업데이트
    private func updateScheduleList(category: String? = "전체") {
        if category == "전체" {
            filteredSchedules = allSchedules.map { $0.title }
        } else {
            filteredSchedules = allSchedules.filter { $0.category == category }.map { $0.title }
        }

        DispatchQueue.main.async {
            self.homeView.scheduleModalView.schedules = self.filteredSchedules
        }
    }

    // MARK: - FSCalendarDelegate
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        //homeView.updateHeaderLabel()
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        homeView.calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Actions
    @objc func addScheduleButtonTapped() {
        let addVC = AddScheduleViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }

    @objc func alarmButtonTapped() {
        let alarmVC = AlarmViewController()
        self.navigationController?.pushViewController(alarmVC, animated: true)
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
// MARK: - ScheduleModalViewDelegate
extension HomeViewController: ScheduleModalViewDelegate {
    func didSelectCategory(_ category: String?) {
        updateScheduleList(category: category)
    }
}
*/
