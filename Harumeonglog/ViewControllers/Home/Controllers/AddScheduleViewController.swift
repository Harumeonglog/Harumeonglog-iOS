//
//  AddScheduleViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit

class AddScheduleViewController: UIViewController {

    private lazy var addScheduleView: AddScheduleView = {
        let view = AddScheduleView()
        view.delegate = self  // ✅ Delegate 설정
        view.timeButton.addTarget(self, action: #selector(showDateTimePicker), for: .touchUpInside)
        return view
    }()

    private var categoryInputView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addScheduleView
    }
    @objc private func showDateTimePicker() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels // iOS 스타일 유지
        datePicker.locale = Locale(identifier: "ko_KR") // 한글 요일 표시
        datePicker.timeZone = TimeZone.current
        datePicker.minuteInterval = 5 // 5분 간격 선택 가능
        
        alertController.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(alertController.view)
            make.top.equalTo(alertController.view).offset(10)
        }
        
        let confirmAction = UIAlertAction(title: "선택", style: .default) { _ in
            let selectedDate = datePicker.date
            self.addScheduleView.timeButton.setTitle(self.getFormattedDate(selectedDate), for: .normal) // ✅ 선택한 날짜 업데이트
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // ✅ 오류 수정: self.window?.rootViewController 대신 self.present 사용
        self.present(alertController, animated: true, completion: nil)
    }
    // ✅ 날짜 포맷 변환 (2025.3.17 월요일 형식)
        private func getFormattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy.M.d EEEE"
            return formatter.string(from: date)
        }
}

// Delegate 구현하여 선택된 카테고리에 따라 입력 필드 표시
extension AddScheduleViewController: AddScheduleViewDelegate {
    func categoryDidSelect(_ category: CategoryType) {
        updateCategoryInputView(for: category)
    }

    private func updateCategoryInputView(for category: CategoryType) {
        categoryInputView?.removeFromSuperview()
        
        switch category {
        case .bath:
            categoryInputView = BathView()
        case .walk:
            categoryInputView = WalkView()
        case .medicine:
            categoryInputView = MedicineView()
        case .checkup:
            categoryInputView = CheckupView()
        case .other:
            categoryInputView = OtherView()
        }
        
        if let newView = categoryInputView {
            view.addSubview(newView)
            view.bringSubviewToFront(newView)
            newView.snp.makeConstraints { make in
                make.top.equalTo(addScheduleView.categoryButton.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(300)
            }
        }
        view.bringSubviewToFront(addScheduleView.dropdownTableView)
    }
}
