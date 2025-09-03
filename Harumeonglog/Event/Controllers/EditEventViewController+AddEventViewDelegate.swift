//
//  EditEventViewController+.swift
//  Harumeonglog
//
//  Created by Dana Lim on 6/16/25.
//
import UIKit
import SnapKit

//사용자가 버튼 눌렀을때 이벤트 처리할 수 있게
extension EditEventViewController: AddEventViewDelegate {
    
    func dateButtonTapped() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let alert = UIAlertController(title: "날짜 선택", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        datePicker.frame = CGRect(x: 0, y: 20, width: alert.view.bounds.width - 20, height: 200)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: datePicker.date)
            self.editEventView.dateButton.setTitle(dateString, for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    func timeButtonTapped() {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        let alert = UIAlertController(title: "시간 선택", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(timePicker)
        timePicker.frame = CGRect(x: 0, y: 20, width: alert.view.bounds.width - 20, height: 200)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let timeString = formatter.string(from: timePicker.date)
            self.editEventView.timeButton.setTitle(timeString, for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func weekdayTapped(_ weekday: String, isSelected: Bool) {
        if isSelected {
            self.selectedWeekdays.insert(weekday)
        } else {
            self.selectedWeekdays.remove(weekday)
        }

        for button in editEventView.weekButtons {
            if button.titleLabel?.text == weekday {
                button.backgroundColor = isSelected ? .brown01 : .white
                button.setTitleColor(isSelected ? .white : .gray00, for: .normal)
            }
        }
    }
    func categoryDidSelect(_ category: CategoryType) {
        editEventView.updateCategoryInputView(for: category)
    }
    func getSelectedWeekdays() -> [String] {
        return Array(self.selectedWeekdays)
    }
}
