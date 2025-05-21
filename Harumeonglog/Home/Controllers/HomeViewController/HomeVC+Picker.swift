//
//  HomeViewController+Picker.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
//



import UIKit
import SnapKit

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    var years: [Int] { Array(2000...2030) }
    var months: [Int] { Array(1...12) }

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

    func changeMonth(toYear year: Int, month: Int) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        if let date = Calendar.current.date(from: components) {
            setCalendarTo(date: date)
            fetchEventDatesForCurrentMonth()
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? years.count : months.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        component == 0 ? "\(years[row])년" : "\(months[row])월"
    }
}
