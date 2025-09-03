//
//  EditEventViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/16/25.
//

import UIKit
import SnapKit
import Alamofire

protocol EditEventViewControllerDelegate: AnyObject {
    func didDeleteEvent(eventId: Int)
    func didUpdateEvent(_ updatedEventId: Int)
}

struct EventDetailData {
    let category: CategoryType
    let fields: [String: String]
}

protocol EventDetailReceivable {
    func applyContent(from data: EventDetailData)
}

class EditEventViewController: UIViewController {
    
    weak var delegate: EditEventViewControllerDelegate?
    
    var event: EventDetailResult?

    var selectedWeekdays: Set<String> = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //수정할 이벤트 아이디
    var eventId: Int
    private var isEditable: Bool
    
    init(eventId: Int){
        self.eventId = eventId
        self.isEditable = true
        super.init(nibName: nil, bundle: nil)
    }

    init(event: EventDetailResult, isEditable: Bool) {
        self.eventId = event.id
        self.isEditable = isEditable
        self.event = event
        super.init(nibName: nil, bundle: nil)
        // TODO: 추후 event 내용 세팅
    }
    
    lazy var editEventView: AddEventView = {
        let view = AddEventView()
        view.isEditable = self.isEditable
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editEventView
        setCustomNavigationBarConstraints()
        
        editEventView.deleteEventButton.isHidden = !isEditable
        if isEditable {
            editEventView.deleteEventButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        }
        
        if let event = event {
            configureData(with: event)
        }
        
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
        let navi = editEventView.navigationBar
        if isEditable {
            navi.configureTitle(title: "일정 상세")
            navi.configureRightButton(text: "수정")
            navi.rightButton.setTitleColor(.blue01, for: .normal)
            navi.rightButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 17)
            navi.rightButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        } else {
            navi.configureTitle(title: "일정 상세")
            navi.rightButton.isHidden = true
        }
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
    //수정버튼 누르면 실행되는 함수
    @objc
    private func editButtonTapped() {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken 없음")
            return
        }
        let request = generateRequestFromView()
        print("=== 수정 요청 파라미터 확인 ===")
        print("title:", request.title)
        print("date:", request.date)
        print("time:", request.time)
        print("alarm:", request.hasNotice ? "알람 있음" : "없음")
        print("category:", request.category)
        print("repeatDays:", request.repeatDays)
        print("isRepeated:", request.isRepeated)
        print("hasNotice:", request.hasNotice)
        print("expiredDate:", request.expiredDate)
        print("details:", request.details ?? "nil")
        print("hospitalName:", request.hospitalName ?? "nil")
        print("department:", request.department ?? "nil")
        print("cost:", request.cost ?? 0)
        print("medicineName:", request.medicineName ?? "nil")
        print("distance:", request.distance ?? "nil")
        print("duration:", request.duration ?? "nil")
        print("===================================")

        // 실제 전송되는 JSON 출력
        if let jsonData = try? JSONEncoder().encode(request),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("전송되는 JSON:\n\(jsonString)")
        }

        EventService.updateEvent(eventId: self.eventId, request: request, token: token) { result in
            switch result {
            case .success(let response):
                print("일정 수정 성공: \(response.message)")
                print("서버 응답 전체: \(response)")
                
                // 수정 성공 후 최신 데이터를 다시 가져와서 화면 갱신
                if let updatedEvent = response.result {
                    DispatchQueue.main.async {
                        self.event = EventDetailResult(
                            id: updatedEvent.id,
                            title: updatedEvent.title,
                            date: updatedEvent.date,
                            isRepeated: updatedEvent.isRepeated,
                            repeatDays: updatedEvent.repeatDays,
                            expiredDate: updatedEvent.expiredDate,
                            hasNotice: updatedEvent.hasNotice,
                            category: updatedEvent.category,
                            time: updatedEvent.time,
                            updatedAt: updatedEvent.updatedAt,
                            hospitalName: updatedEvent.hospitalName,
                            department: updatedEvent.department,
                            cost: updatedEvent.cost,
                            details: updatedEvent.details,
                            medicineName: updatedEvent.medicineName,
                            distance: updatedEvent.distance,
                            duration: updatedEvent.duration
                        )
                        
                        // 화면 갱신
                        print("=== 화면 갱신 시작 ===")
                        print("업데이트된 event 데이터:")
                        print("  title: \(self.event?.title ?? "nil")")
                        print("  hospitalName: \(self.event?.hospitalName ?? "nil")")
                        print("  department: \(self.event?.department ?? "nil")")
                        print("  cost: \(self.event?.cost ?? 0)")
                        print("  details: \(self.event?.details ?? "nil")")
                        
                        self.configureData(with: self.event!)
                        print("=== configureData 완료 ===")
                        
                        self.delegate?.didUpdateEvent(self.eventId)
                        print("=== delegate 호출 완료 ===")
                        
                        // 홈화면으로 돌아가기
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.navigationController?.popViewController(animated: true)
                            print("=== 홈화면으로 돌아가기 완료 ===")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.didUpdateEvent(self.eventId)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                print("일정 수정 실패: \(error)")
                if let afError = error.underlyingError as? AFError {
                    print("AFError: \(afError)")
                    if let data = (afError.underlyingError as? NSError)?.userInfo["com.alamofire.serialization.response.error.data"] as? Data,
                       let json = String(data: data, encoding: .utf8) {
                        print("서버 에러 응답 본문: \(json)")
                    }
                } else {
                    print("기타 오류: \(error.localizedDescription)")
                }
            }
        }
    }

    //뷰에서 EventRequest 생성 (fallback logic 포함)
    private func generateRequestFromView() -> EventRequest {
        // 1. 입력값이 비어있으면 기존 event 데이터로 fallback
        let title = editEventView.titleTextField.text?.isEmpty == false
            ? editEventView.titleTextField.text!
            : (event?.title ?? "")

        let date = (editEventView.dateButton.title(for: .normal) != nil && editEventView.dateButton.title(for: .normal) != "")
            ? editEventView.dateButton.title(for: .normal)!
            : (event?.date ?? "")

        let time = (editEventView.timeButton.title(for: .normal) != nil && editEventView.timeButton.title(for: .normal) != "")
            ? editEventView.timeButton.title(for: .normal)!
            : (event?.time ?? "")

        let hasNotice = false // 알림 기능 제거됨

        // 2. 카테고리도 기존 event category fallback
        let categoryTitle = editEventView.categoryButton.title(for: .normal) ?? ""
        let category = CategoryType.allCases.first { $0.displayName == categoryTitle }?.serverKey ?? event?.category ?? ""

        // 3. 반복 요일도 선택하지 않았을 경우 기존 값 사용
        let repeatDays: [String]
        if selectedWeekdays.isEmpty, let existingRepeatDays = self.event?.repeatDays {
            repeatDays = existingRepeatDays
        } else {
            repeatDays = selectedWeekdays.toEnglishWeekdays()
        }
        let isRepeated = !repeatDays.isEmpty
        let expiredDate = date

        var request = EventRequest(
            title: title,
            date: date,
            isRepeated: isRepeated,
            expiredDate: expiredDate,
            repeatDays: repeatDays,
            hasNotice: hasNotice,
            time: time,
            category: category,
            details: nil,
            hospitalName: nil,
            department: nil,
            cost: nil,
            medicineName: nil,
            distance: nil,
            duration: nil
        )

        switch category {
            // EditEventViewController의 generateRequestFromView()에서
            case "HOSPITAL":
                if let view = editEventView.categoryInputView as? CheckupView {
                    let input = view.getInput() // 👈 이 메서드를 사용해야 함
                    request.hospitalName = input.hospitalName.isEmpty ? nil : input.hospitalName
                    request.department = input.department.isEmpty ? nil : input.department
                    request.cost = input.cost.isEmpty ? nil : Int(input.cost)
                    request.details = input.details.isEmpty ? nil : input.details
                    
                    print(" HOSPITAL getInput() 결과:")
                    print("  병원명: \(input.hospitalName)")
                    print("  진료과: \(input.department)")
                    print("  비용: \(input.cost)")
                    print("  상세내용: \(input.details)")
                }
        case "MEDICINE":
            if let view = editEventView.categoryInputView as? MedicineView {
                let input = view.getInput() // MedicineView에도 getInput() 메서드가 있다고 가정
                request.medicineName = input.medicineName.isEmpty ? nil : input.medicineName
                request.details = input.details.isEmpty ? nil : input.details
            }

        case "WALK":
            if let view = editEventView.categoryInputView as? WalkView {
                let input = view.getInput() // WalkView에도 getInput() 메서드가 있다고 가정
                request.distance = input.distance.isEmpty ? nil : input.distance
                request.duration = input.duration.isEmpty ? nil : input.duration
                request.details = input.details.isEmpty ? nil : input.details
            }

        case "OTHER":
            if let view = editEventView.categoryInputView as? OtherView {
                let input = view.getInput()
                request.details = input.isEmpty ? nil : input
            }
        default:
            break
        }
        return request
    }
    
    //삭제 버튼 누르면 실행되는 함수
    @objc
    private func deleteButtonTapped(){
        let alertController = UIAlertController(title: "일정 삭제", message: "일정을 정말 삭제하시겠습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        let deleteAction = UIAlertAction(title:"삭제", style: .destructive) { _ in
            guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
                print("AccessToken 없음")
                return
            }
            
            EventService.deleteEvent(eventId: self.eventId, token: token){ result in
                switch result {
                case .success(let response):
                    print("일정 삭제 성공: \(response.message)")
                    DispatchQueue.main.async {
                        //삭제 후 delegate 호출
                        self.delegate?.didDeleteEvent(eventId: self.eventId)
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("일정 삭제 실패: \(error)")
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)

        //api에 전달, pop navigator controller, 삭제된거 없어져있어야함
    }
        
    
    private func configureData(with event: EventDetailResult) {
        print("=== configureData 시작 ===")
        print("받은 event 데이터:")
        print("  title: \(event.title)")
        print("  hospitalName: \(event.hospitalName ?? "nil")")
        print("  department: \(event.department ?? "nil")")
        print("  cost: \(event.cost ?? 0)")
        print("  details: \(event.details ?? "nil")")
        
        editEventView.titleTextField.text = event.title
        editEventView.dateButton.setTitle(event.date, for: .normal)
        editEventView.timeButton.setTitle(event.time, for: .normal)
        
        if let categoryType = CategoryType.fromServerValue(event.category) {
            editEventView.categoryButton.setTitle(categoryType.displayName, for: .normal)
        } else {
            editEventView.categoryButton.setTitle(event.category, for: .normal)
        }

        editEventView.categoryButton.setTitleColor(.gray00, for: .normal)

        let koreanDays = Set(event.repeatDays).toKoreanWeekdays()

        self.editEventView.weekButtons.forEach { button in
            if let dayText = button.titleLabel?.text, koreanDays.contains(dayText) {
                button.isSelected = true
                button.backgroundColor = .brown01
                button.setTitleColor(.white, for: .normal)
                button.tintColor = .clear // 선택 시 파란색 없애기
            }
        }

        if let categoryType = CategoryType.fromServerValue(event.category) {
            print("카테고리 뷰 업데이트 시작: \(categoryType)")
            editEventView.updateCategoryInputView(for: categoryType)

            DispatchQueue.main.async {
                // 뷰가 준비될 때까지 잠시 대기
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    print("카테고리별 데이터 설정 시작")
                    switch event.category {
                    case "HOSPITAL":
                        if let view = self.editEventView.categoryInputView as? CheckupView {
                            print("CheckupView 데이터 설정:")
                            print("  hospitalName: \(event.hospitalName ?? "nil")")
                            print("  department: \(event.department ?? "nil")")
                            print("  cost: \(event.cost ?? 0)")
                            print("  details: \(event.details ?? "nil")")
                            
                            view.hospitalTextField.text = event.hospitalName
                            view.departmentTextField.text = event.department
                            view.costTextField.text = "\(event.cost ?? 0)"
                            view.detailTextView.text = event.details
                            print("CheckupView 데이터 설정 완료")
                        } else {
                            print("CheckupView 캐스팅 실패")
                        }
                    case "MEDICINE":
                        if let view = self.editEventView.categoryInputView as? MedicineView {
                            view.medicineNameTextField.text = event.medicineName
                            view.detailTextView.text = event.details
                        }
                    case "WALK":
                        if let view = self.editEventView.categoryInputView as? WalkView {
                            view.distanceTextField.text = event.distance
                            view.timeTextField.text = event.duration
                            view.detailTextView.text = event.details
                        }

                    case "OTHER":
                        if let view = self.editEventView.categoryInputView as? OtherView {
                            view.detailTextView.text = event.details
                        }
                    default:
                        break
                    }
                    print("카테고리별 데이터 설정 완료")
                }
            }
        }
        print("=== configureData 완료 ===")
    }
    
    private func populateUI(date: String, time: String, alarm: String, weekdays: [String], detail: EventDetailData) {
            editEventView.dateButton.setTitle(date, for: .normal)
            editEventView.timeButton.setTitle(time, for: .normal)

        weekdays.forEach { day in
            _ = editEventView.weekButtons.first(where: { $0.titleLabel?.text == day })?.sendActions(for: .touchUpInside)
        }

        editEventView.categoryButton.setTitle(detail.category.rawValue, for: .normal)
        editEventView.updateCategoryInputView(for: detail.category)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let receivableView = self.editEventView.categoryInputView as? EventDetailReceivable {
                receivableView.applyContent(from: detail)
            }
        }
    }
}

