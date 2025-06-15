//
//  EditEventViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/16/25.
//

import UIKit
import SnapKit

struct EventDetailData {
    let category: CategoryType
    let fields: [String: String]
}

protocol EventDetailReceivable {
    func applyContent(from data: EventDetailData)
}

class EditEventViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //수정할 이벤트 아이디
    var eventId: Int
    
    init(eventId: Int){
        self.eventId = eventId
        super.init(nibName: nil, bundle: nil)
    }

    init(event: EventDetailResult) {
        self.eventId = event.id
        super.init(nibName: nil, bundle: nil)
        //TODO
    }
    
    private lazy var editEventView: AddEventView = {
        let view = AddEventView()
        view.isEditable = true
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editEventView
        setCustomNavigationBarConstraints()
        
        editEventView.deleteEventButton.isHidden = false
        editEventView.deleteEventButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        fetchEventData()
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
        navi.configureTitle(title: "일정 수정")
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
    
    @objc
    private func saveButtonTapped(){
        //저장버튼 누르면 실행되는 함수
        //api에 전달, pop navigator controller
    }
    
    @objc
    private func deleteButtonTapped(){
        //삭제 버튼 누르면 실행되는 함수
        //api에 전달, pop navigator controller, 삭제된거 없어져있어야함
    }
    
    
    private func fetchEventData() {
        // 테스트용 더미 데이터
        var detail: EventDetailData

        switch eventId {
        case 0:
            detail = EventDetailData(category: .bath, fields: ["detail": "따뜻한 물로 반신욕"])
        case 1:
            detail = EventDetailData(category: .walk, fields: ["distance": "1.5", "time": "30", "detail": "공원 산책"])
        case 2:
            detail = EventDetailData(category: .checkup, fields: ["hospital": "우리동물병원", "department": "피부", "cost": "15000", "detail": "피부 알러지 검진"])
        case 3:
            detail = EventDetailData(category: .other, fields: ["detail": "목욕 겸 놀이시간"])
        default:
            detail = EventDetailData(category: .other, fields: ["detail": ""])
        }

        populateUI(date: "2025.4.16 수요일", time: "10:30", alarm: "30분 전 팝업", weekdays: ["월", "수"], detail: detail)
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
