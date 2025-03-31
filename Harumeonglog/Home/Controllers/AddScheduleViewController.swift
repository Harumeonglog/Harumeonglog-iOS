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
        view.delegate = self
        return view
    }()

    private var categoryInputView: UIView?
    //선택된 요일 저장하는 배열
    private var selectedWeekdays: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addScheduleView
        setCustomNavigationBarConstraints()
        
        addScheduleView.dateButton.addTarget(self, action: #selector(showDateTimePicker), for: .touchUpInside)
        addScheduleView.timeButton.addTarget(self, action: #selector(showDateTimePicker), for: .touchUpInside)
        for button in addScheduleView.weekButtons {
            button.addTarget(self, action: #selector(weekButtonTapped), for: .touchUpInside)
        }
        addScheduleView.alarmButton.addTarget(self, action: #selector(alertButtonTapped), for: .touchUpInside)
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = addScheduleView.navigationBar
        navi.configureTitle(title: "일정 추가")
        navi.configureRightButton(text: "저장")
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    // 요일 버튼 클릭 시 동작
    @objc private func weekButtonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        if selectedWeekdays.contains(title) {
            // 이미 선택된 요일 -> 선택 해제
            selectedWeekdays.remove(title)
            sender.backgroundColor = .white
            sender.setTitleColor(.gray00, for: .normal)
        } else {
            // 새로운 요일 선택
            selectedWeekdays.insert(title)
            sender.backgroundColor = .brown01
            sender.setTitleColor(.white, for: .normal)
        }
        
        print("선택된 요일: \(selectedWeekdays)")
    }
    
    //날짜 선택하는 메서드 함수
    @objc private func showDateTimePicker() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR") // 한글 요일 표시
        datePicker.timeZone = TimeZone.current
        datePicker.minuteInterval = 10 // 5분 간격 선택 가능
        
        alertController.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(alertController.view)
            make.top.equalTo(alertController.view).offset(10)
        }
        
        let confirmAction = UIAlertAction(title: "선택", style: .default) { _ in
            let selectedDate = datePicker.date
            
            UIView.performWithoutAnimation {
                self.addScheduleView.dateButton.setTitle(self.getFormattedDate(selectedDate), for: .normal)
                self.addScheduleView.timeButton.setTitle(self.getFormattedTime(selectedDate), for: .normal)
                self.addScheduleView.layoutIfNeeded() // 즉시 적용
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func alertButtonTapped() {
        let alertController = UIAlertController(title: "알림 설정", message: nil, preferredStyle: .actionSheet)

        // 알림 옵션 목록
        let alarmOptions: [(title: String, minutes: Int?)] = [
            ("설정 안 함", nil),
            ("10분 전 팝업", 10),
            ("30분 전 팝업", 30),
            ("1시간 전 팝업", 60),
            ("하루 전 팝업", 1440)
        ]
        
        // 옵션을 UIAlertAction으로 추가
        for option in alarmOptions {
            let action = UIAlertAction(title: option.title, style: .default) { _ in
                UIView.performWithoutAnimation { // UI 깜빡임 방지
                    self.addScheduleView.alarmButton.setTitle(option.title, for: .normal)
                    self.addScheduleView.layoutIfNeeded()
                }
            }
            alertController.addAction(action)
        }
        
        // 취소 버튼 추가
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 모달 표시
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 날짜 변환 (2025.3.10 월요일 형식)
     func getFormattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.M.d EEEE" // 시간 없이 날짜만 표시
        return formatter.string(from: date)
    }

    // 시간 변환 (08:00 형식)
     func getFormattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm" // 24시간 형식
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
