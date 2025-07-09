//
//  AddEventViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit
import Alamofire

private enum PickerMode {
    case date
    case time
}

class AddEventViewController: UIViewController {

    private lazy var addEventView: AddEventView = {
        let view = AddEventView()
        view.delegate = self
        return view
    }()

    //선택된 요일 저장하는 배열
    private var selectedWeekdays: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addEventView
        setCustomNavigationBarConstraints()
        
        // 현재 날짜와 시간으로 초기화
        setInitialDateTime()
        
        // 키보드 숨김 기능 추가
        hideKeyboardWhenTappedAround()
    }


    
    //탭바 숨기기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setCustomNavigationBarConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let navi = addEventView.navigationBar
        navi.configureTitle(title: "일정 추가")
        navi.configureRightButton(text: "저장")
        navi.rightButton.setTitleColor(.blue01, for: .normal)
        navi.rightButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 17)
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        navi.rightButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    //저장버튼 동작 함수
    @objc
    private func saveButtonTapped(){
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken),
              let selectedCategory = addEventView.selectedCategory else { return }
        
        let input = collectEventInput(for: selectedCategory)
        let request = makeEventRequest(from: input, category: selectedCategory)
        
        postEvent(request: request, token: accessToken)
    }
    
    
    private func setInitialDateTime() {
        let currentDate = Date()
        let formattedDate = getFormattedDate(currentDate)  // 현재 날짜
        let formattedTime = getFormattedTime(currentDate)  // 현재 시간
        
        // dateButton과 timeButton에 현재 날짜와 시간 설정
        addEventView.dateButton.setTitle(formattedDate, for: .normal)
        addEventView.timeButton.setTitle(formattedTime, for: .normal)
    }
    
    //날짜 선택하는 메서드 함수
    private func showDateTimePicker(for mode: PickerMode) {
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
                switch mode {
                case .date:
                    self.addEventView.dateButton.setTitle(self.getFormattedDate(selectedDate), for: .normal)
                case .time:
                    self.addEventView.timeButton.setTitle(self.getFormattedTime(selectedDate), for: .normal)
                }
                self.addEventView.layoutIfNeeded() // 즉시 적용
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
                    self.addEventView.alarmButton.setTitle(option.title, for: .normal)
                    self.addEventView.layoutIfNeeded()
                }
                self.alarmOptionSelected(option.title)
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
        formatter.dateFormat = "yyyy-MM-dd"
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

// MARK: Delegate 구현하여 선택된 카테고리에 따라 입력 필드 표시
extension AddEventViewController: AddEventViewDelegate {
    func categoryDidSelect(_ category: CategoryType) {
        updateCategoryInputView(for: category)
    }

    func dateButtonTapped() {
        showDateTimePicker(for: PickerMode.date)
    }

    func timeButtonTapped() {
        showDateTimePicker(for: PickerMode.time)
    }

    func alarmButtonTapped() {
        alertButtonTapped()
    }

    func weekdayTapped(_ weekday: String, isSelected: Bool) {
        if isSelected {
            selectedWeekdays.insert(weekday)
        } else {
            selectedWeekdays.remove(weekday)
        }

        // 버튼 상태 반영
        for button in addEventView.weekButtons {
            if button.titleLabel?.text == weekday {
                button.backgroundColor = isSelected ? .brown01 : .white
                button.setTitleColor(isSelected ? .white : .gray00, for: .normal)
            }
        }

        print("선택된 요일: \(selectedWeekdays)")
    }

    private func updateCategoryInputView(for category: CategoryType) {
        addEventView.updateCategoryInputView(for: category)
    }

    func getSelectedWeekdays() -> [String] {
        return selectedWeekdays.toEnglishWeekdays()
    }

    func alarmOptionSelected(_ option: String) {
        // TODO알람 옵션 선택 시 처리 로직 추가 가능
    }
}

//MARK: 일정 추가 API 연결
extension AddEventViewController {
    
    //사용자가 입력한 카테고리별로 정보 가져오는 메서드
    private func collectEventInput(for category: CategoryType) -> (details: String, hospitalName: String, department: String, cost: Int, medicineName: String, distance: String, duration: String) {
        var details = "", hospitalName = "", department = "", medicineName = "", distance = "", duration = ""
        var cost = 0
        
        switch category {
        case .walk:
            if let view = addEventView.categoryInputView as? WalkView {
                let input = view.getInput()
                distance = input.distance
                duration = input.duration
                details = input.details
            }
        case .medicine:
            if let view = addEventView.categoryInputView as? MedicineView {
                let input = view.getInput()
                medicineName = input.medicineName
                details = input.details
            }
        case .checkup:
            if let view = addEventView.categoryInputView as? CheckupView {
                let input = view.getInput()
                hospitalName = input.hospitalName
                department = input.department
                cost = Int(input.cost) ?? 0
                details = input.details
            }
        case .bath:
            break
        case .other:
            if let view = addEventView.categoryInputView as? OtherView {
                details = view.getInput()
            }
        }
        
        return (details, hospitalName, department, cost, medicineName, distance, duration)
    }
    
    //입력값 가지고 서버에 보낼 EventRequest 객체 만드는 메서드
    func makeEventRequest(from input: (details: String, hospitalName: String, department: String, cost: Int, medicineName: String, distance: String, duration: String), category: CategoryType) -> EventRequest {
        
        let dateText = addEventView.dateButton.title(for: .normal) ?? ""
        let timeText = addEventView.timeButton.title(for: .normal) ?? "00.00"
        let timeComponents = timeText.split(separator: ":")
        let hour = Int(timeComponents[0]) ?? 0
        let minute = Int(timeComponents[1]) ?? 0
        
        let formattedTime = String(format: "%02d:%02d:00", hour, minute)
        
        print("보내는 category 값: \(category.serverKey)")
        
        return EventRequest(
            title: addEventView.titleTextField.text ?? "",
            date: dateText,
            isRepeated: !selectedWeekdays.isEmpty,
            expiredDate: "2025-12-31",
            repeatDays: getSelectedWeekdays(),
            hasNotice: addEventView.alarmButton.title(for: .normal) != "설정 안 함",
            time: formattedTime,
            category: category.serverKey,
            details: category == .walk || category == .medicine || category == .checkup || category == .other ? input.details : nil,
            hospitalName: category == .checkup ? input.hospitalName : nil,
            department: category == .checkup ? input.department : nil,
            cost: category == .checkup ? input.cost : nil,
            medicineName: category == .medicine ? input.medicineName : nil,
            distance: category == .walk ? input.distance : nil,
            duration: category == .walk ? input.duration : nil
        )
    }
    
    //createEvent 불러오기
    private func postEvent(request: EventRequest, token: String) {
        // JSON 로그 출력 추가
        if let jsonData = try? JSONEncoder().encode(request),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("전송되는 JSON:\n\(jsonString)")
        }
        
        EventService.createEvent(request: request, token: token) { result in
            switch result {
            case .success(let response):
                print("일정 추가 성공 !!: \(response)")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print("일정 추가 실패 ㅜㅜ: \(error)")
                
                if let afError = error.underlyingError as? AFError,
                   case let .responseSerializationFailed(reason) = afError,
                   case let .decodingFailed(decodingError) = reason {
                    print("디코딩 오류 내용: \(decodingError)")
                }
                
                if let underlyingError = error.underlyingError,
                   let data = (underlyingError as NSError).userInfo["com.alamofire.serialization.response.error.data"] as? Data,
                   let json = String(data: data, encoding: .utf8) {
                    print("서버 응답 JSON 본문:\n\(json)")
                } else {
                    print("응답 데이터 없음")
                }
            }
        }
    }
}
