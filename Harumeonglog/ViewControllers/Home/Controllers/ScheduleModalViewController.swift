//
//  ScheduleModalViewController.swift
//  Harumeonglog
//

import UIKit
import SnapKit

protocol ScheduleModalDelegate: AnyObject {
    func toggleCalendar() // ✅ 캘린더 확장/축소 함수
}

class ScheduleModalViewController: UIViewController {

    weak var delegate: ScheduleModalDelegate? // ✅ Delegate 선언
    
    private var allSchedules: [(category: String, title: String)] = [
        ("위생", "목욕하기"),
        ("건강", "병원 가기"),
        ("산책", "공원 산책"),
        ("기타", "친구 만나기"),
        ("건강", "운동하기"),
        ("산책", "강아지랑 걷기"),
        ("위생", "손톱 깎기")
    ]
    
    private var filteredSchedules: [String] = [] // 필터링된 일정 리스트

    private lazy var scheduleModalView: ScheduleModalView = {
        let view = ScheduleModalView()
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = scheduleModalView
        updateScheduleList() // 초기 로드
    }

    // ✅ 카테고리 선택 시 일정 업데이트
    private func updateScheduleList(category: String? = "전체") {
        if category == "전체" {
            filteredSchedules = allSchedules.map { $0.title }
        } else {
            filteredSchedules = allSchedules.filter { $0.category == category }.map { $0.title }
        }
        scheduleModalView.schedules = filteredSchedules
    }
}

// ✅ ScheduleModalViewDelegate 채택
extension ScheduleModalViewController: ScheduleModalViewDelegate {
    func toggleCalendar() {
        delegate?.toggleCalendar()
    }
    
    func didSelectCategory(_ category: String?) {
        updateScheduleList(category: category)
    }
}
