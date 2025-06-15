//
//  EditEventViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/16/25.
//

import UIKit
import SnapKit

protocol EditEventViewControllerDelegate: AnyObject {
    func didDeleteEvent(eventId: Int)
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
    
    private var event: EventDetailResult?
    
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
    
    private lazy var editEventView: AddEventView = {
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
            navi.configureTitle(title: "일정 수정")
            navi.configureRightButton(text: "저장")
            navi.rightButton.setTitleColor(.blue01, for: .normal)
            navi.rightButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 17)
            navi.rightButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
    
    //저장버튼 누르면 실행되는 함수
    @objc
    private func saveButtonTapped(){
        //api에 전달, pop navigator controller
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
        editEventView.titleTextField.text = event.title
        editEventView.dateButton.setTitle(event.date, for: .normal)
        editEventView.timeButton.setTitle(event.time, for: .normal)
        editEventView.categoryButton.setTitle(event.category, for: .normal)
        editEventView.categoryButton.setTitleColor(.gray00, for: .normal)

        let weekdayMap: [String: String] = [
            "MON": "월", "TUE": "화", "WED": "수",
            "THU": "목", "FRI": "금", "SAT": "토", "SUN": "일"
        ]

        event.repeatDays.forEach { code in
            if let koreanDay = weekdayMap[code] {
                for button in self.editEventView.weekButtons {
                    if button.titleLabel?.text == koreanDay {
                        // 선택 토글이 아닌 선택된 상태로 강제 설정
                        button.isSelected = true
                        button.backgroundColor = .brown01
                        button.setTitleColor(.white, for: .normal)
                    }
                }
            }
        }

        if let categoryType = CategoryType.fromServerValue(event.category) {
            editEventView.updateCategoryInputView(for: categoryType)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            switch event.category {
            case "HOSPITAL":
                if let view = self.editEventView.categoryInputView as? CheckupView {
                    view.hospitalTextField.text = event.hospitalName
                    view.departmentTextField.text = event.department
                    view.costTextField.text = "\(event.cost ?? 0)"
                    view.detailTextView.text = event.details
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
            case "BATH":
                if let view = self.editEventView.categoryInputView as? BathView {
                    view.detailTextView.text = event.details
                }
            case "OTHER":
                if let view = self.editEventView.categoryInputView as? OtherView {
                    view.detailTextView.text = event.details
                }
            default:
                break
            }
        }
    }
    
    private func populateUI(date: String, time: String, alarm: String, weekdays: [String], detail: EventDetailData) {
            editEventView.dateButton.setTitle(date, for: .normal)
            editEventView.timeButton.setTitle(time, for: .normal)
            editEventView.alarmButton.setTitle(alarm, for: .normal)

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

extension EditEventViewController: AddEventViewDelegate {
    func dateButtonTapped() {}
    func timeButtonTapped() {}
    func alarmButtonTapped() {}
    func weekdayTapped(_ weekday: String, isSelected: Bool) {}
    func categoryDidSelect(_ category: CategoryType) {
        editEventView.updateCategoryInputView(for: category)
    }
    func getSelectedWeekdays() -> [String] { return [] }
    func alarmOptionSelected(_ option: String) {}
}
