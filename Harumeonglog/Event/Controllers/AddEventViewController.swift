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

protocol AddEventViewControllerDelegate: AnyObject {
    func didAddEvent()
}

class AddEventViewController: UIViewController {
    
    var selectedDate: Date = Date() // 홈화면에서 선택된 날짜
    weak var delegate: AddEventViewControllerDelegate?
    
    private var selectedCategory: CategoryType? // 선택된 카테고리 저장
    private var isSaving: Bool = false
    
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
        
        addEventView.delegate = self
        
        setCustomNavigationBarConstraints()
        
        // 현재 날짜와 시간으로 초기화
        setInitialDateTime()

        hideKeyboardWhenTappedAround()
        
        // 선택된 카테고리가 있다면 복원
        if let selectedCategory = selectedCategory {
            print("초기화 시 선택된 카테고리 복원: \(selectedCategory.rawValue)")
            updateCategoryInputView(for: selectedCategory)
        }
        swipeRecognizer()
    }
    
    //탭바 숨기기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        addKeyboardObservers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        removeKeyboardObservers()
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
        // 중복 탭 방지: 진행 중이면 무시
        if isSaving { return }
        
        // 필수 값 확인
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken),
              let selectedCategory = addEventView.selectedCategory else { return }
        
        let input = collectEventInput(for: selectedCategory)
        let request = makeEventRequest(from: input, category: selectedCategory)
        
        // 확인 팝업 표시
        let alert = UIAlertController(title: "등록", message: "일정을 등록하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.isSaving = true
            self.addEventView.navigationBar.rightButton.isEnabled = false
            self.postEvent(request: request, token: accessToken)
        }))
        present(alert, animated: true)
    }
    
    
    private func setInitialDateTime() {
        let currentDate = selectedDate // 선택된 날짜 사용
        let formattedDate = getFormattedDate(currentDate)  // 선택된 날짜
        let formattedTime = getFormattedTime(currentDate)  // 현재 시간
        
        // dateButton과 timeButton에 선택된 날짜와 현재 시간 설정
        addEventView.dateButton.setTitle(formattedDate, for: .normal)
        addEventView.timeButton.setTitle(formattedTime, for: .normal)
    }
    
    // 날짜/시간을 각각 선택할 수 있도록 분리
    private func showDateTimePicker(for mode: PickerMode) {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        switch mode {
        case .date:
            datePicker.datePickerMode = .date
        case .time:
            datePicker.datePickerMode = .time
        }
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR") // 한글 요일 표시
        datePicker.timeZone = TimeZone.current
        datePicker.minuteInterval = 10
        
        // 현재 버튼에 표시된 날짜/시간을 초기값으로 설정
        if mode == .date {
            if let text = addEventView.dateButton.title(for: .normal), !text.isEmpty {
                let df = DateFormatter()
                df.locale = Locale(identifier: "ko_KR")
                df.dateFormat = "yyyy-MM-dd"
                if let d = df.date(from: text) {
                    var comps = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: Date())
                    let dayComps = Calendar.current.dateComponents([.year,.month,.day], from: d)
                    comps.year = dayComps.year; comps.month = dayComps.month; comps.day = dayComps.day
                    if let merged = Calendar.current.date(from: comps) { datePicker.setDate(merged, animated: false) }
                }
            }
        } else {
            if let text = addEventView.timeButton.title(for: .normal), !text.isEmpty {
                let tf = DateFormatter()
                tf.locale = Locale(identifier: "ko_KR")
                tf.dateFormat = "HH:mm"
                if let t = tf.date(from: text) {
                    var comps = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: Date())
                    let timeComps = Calendar.current.dateComponents([.hour,.minute], from: t)
                    comps.hour = timeComps.hour; comps.minute = timeComps.minute
                    if let merged = Calendar.current.date(from: comps) { datePicker.setDate(merged, animated: false) }
                }
            }
        }
        
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
                
                // 카테고리 입력 뷰는 재생성하지 않음 (사용자 입력 보존)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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

// MARK: - Keyboard handling (adjust scroll insets)
extension AddEventViewController {
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        let curveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)

        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        let keyboardTopY = view.bounds.height - keyboardHeight
        var requiredInset: CGFloat = 0
        if let responder = view.findFirstResponder() {
            let fieldFrameInView = responder.convert(responder.bounds, to: view)
            if fieldFrameInView.maxY > keyboardTopY {
                requiredInset = (fieldFrameInView.maxY - keyboardTopY) + 24
            }
        }
        if requiredInset > 0 {
            requiredInset = min(max(requiredInset, 12), keyboardHeight - 6)
        }

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            // 최소 필요 인셋만 적용해 과도한 상단 이동 방지
            self.addEventView.scrollView.contentInset.bottom = requiredInset
            self.addEventView.scrollView.scrollIndicatorInsets.bottom = requiredInset
        })
        scrollActiveFieldIntoViewMinimally(keyboardHeight: keyboardHeight)
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        let userInfo = (notification.userInfo ?? [:])
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        let curveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.addEventView.scrollView.contentInset.bottom = 0
            self.addEventView.scrollView.scrollIndicatorInsets.bottom = 0
        })
    }

    private func scrollActiveFieldIntoViewMinimally(keyboardHeight: CGFloat) {
        guard let responder = view.findFirstResponder(),
              responder.isDescendant(of: addEventView.scrollView) else { return }
        let scrollView = addEventView.scrollView
        var visibleRect = scrollView.bounds.inset(by: scrollView.contentInset).insetBy(dx: 0, dy: 12)
        // 키보드 높이만큼 아래 영역을 가린다고 가정하고 보이는 영역 보정
        visibleRect.size.height -= (keyboardHeight + 12)
        var targetRect = responder.convert(responder.bounds, to: scrollView)
        if let textView = responder as? UITextView, let range = textView.selectedTextRange {
            let caret = textView.caretRect(for: range.end)
            targetRect = textView.convert(caret.insetBy(dx: 0, dy: -8), to: scrollView)
        }
        var targetOffset = scrollView.contentOffset
        if targetRect.maxY > visibleRect.maxY {
            targetOffset.y += (targetRect.maxY - visibleRect.maxY)
        } else if targetRect.minY < visibleRect.minY {
            targetOffset.y -= (visibleRect.minY - targetRect.minY)
        } else {
            return 
        }
        targetOffset.y = max(-scrollView.adjustedContentInset.top, min(targetOffset.y, scrollView.contentSize.height - scrollView.bounds.height + scrollView.adjustedContentInset.bottom))
        scrollView.setContentOffset(targetOffset, animated: true)
    }
}

// MARK: Delegate 구현하여 선택된 카테고리에 따라 입력 필드 표시
extension AddEventViewController: AddEventViewDelegate {
    func categoryDidSelect(_ category: CategoryType) {
        selectedCategory = category // 선택된 카테고리 저장
        print("카테고리 선택됨: \(category.rawValue)")
        updateCategoryInputView(for: category)
    }

    func dateButtonTapped() {
        showDateTimePicker(for: PickerMode.date)
    }

    func timeButtonTapped() {
        showDateTimePicker(for: PickerMode.time)
    }

    private func updateCategoryInputView(for category: CategoryType) {
        print("카테고리 입력 뷰 업데이트: \(category.rawValue)")
        addEventView.updateCategoryInputView(for: category)
        
        // 카테고리 버튼 텍스트 업데이트
        addEventView.categoryButton.setTitle(category.rawValue, for: .normal)
        addEventView.categoryButton.setTitleColor(.gray00, for: .normal)
    }

    func getSelectedWeekdays() -> [String] {
        return selectedWeekdays.toEnglishWeekdays()
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
            // OtherView가 생성되지 않았더라도 contentView 안의 OtherView를 탐색해서 입력을 수집
            if let view = addEventView.categoryInputView as? OtherView {
                details = view.getInput()
            } else if let other = addEventView.contentView.subviews.compactMap({ $0 as? OtherView }).first {
                details = other.getInput()
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
            hasNotice: true,
            time: formattedTime,
            category: category.serverKey,
            details: category == .walk || category == .medicine || category == .checkup || category == .other ? (input.details.isEmpty ? nil : input.details) : nil,
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
                    self.isSaving = false
                    self.addEventView.navigationBar.rightButton.isEnabled = true
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.didAddEvent() // 델리게이트 호출
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
                DispatchQueue.main.async {
                    self.isSaving = false
                    self.addEventView.navigationBar.rightButton.isEnabled = true
                }
            }
        }
    }
}
