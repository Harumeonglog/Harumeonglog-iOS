//
//  HomeViewController+Event.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
//  이벤트 관련 로직

import Foundation
import FSCalendar
import Alamofire

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel()
        fetchEventDatesForCurrentMonth()
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        homeView.calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 없음")
            return
        }

        eventViewModel.fetchEventsByDate(date, token: token) { result in
            switch result {
            case .success(let events):
                DispatchQueue.main.async {
                    self.homeView.eventView.updateEvents(events)
                    print("\(self.dateFormatter.string(from: date)) 일정 \(events.count)건 불러옴")
                }
            case .failure(let error):
                print("날짜별 일정 조회 실패: \(error)")
            }
        }
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return markedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) ? 1 : 0
    }
}

