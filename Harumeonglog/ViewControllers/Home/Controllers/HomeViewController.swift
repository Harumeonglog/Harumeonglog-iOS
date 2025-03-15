//
//  HomeViewController.swift
//  Harumeonglog
//

import UIKit
import FSCalendar
import SnapKit

class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, ScheduleModalDelegate {

    private lazy var homeView: HomeView = {
        let view = HomeView()
        view.calendarView.delegate = self
        view.calendarView.dataSource = self
        view.headerLabel.isUserInteractionEnabled = true
        view.calendarView.appearance.eventDefaultColor = .clear // 기본 이벤트 색 제거
        return view
    }()

    private lazy var scheduleModalVC: ScheduleModalViewController = {
        let vc = ScheduleModalViewController()
        vc.delegate = self
        return vc
    }()

    private var isCalendarExpanded = true  // ✅ 캘린더 확장 상태 변수

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        setupScheduleModal()
    }

    private func setupScheduleModal() {
        addChild(scheduleModalVC)
        view.addSubview(scheduleModalVC.view)
        scheduleModalVC.didMove(toParent: self)

        scheduleModalVC.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
    }

    func toggleCalendar() {
        isCalendarExpanded.toggle()
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                if self.isCalendarExpanded {
                    self.homeView.calendarView.setScope(.month, animated: true)
                    self.scheduleModalVC.view.snp.updateConstraints { make in
                        make.height.equalTo(300)
                    }
                } else {
                    self.homeView.calendarView.setScope(.week, animated: true)
                    self.scheduleModalVC.view.snp.updateConstraints { make in
                        make.height.equalTo(self.view.frame.height - 100)
                    }
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    // 📌 **캘린더를 넘길 때 자동으로 헤더 업데이트**
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        homeView.updateHeaderLabel()
    }

}
