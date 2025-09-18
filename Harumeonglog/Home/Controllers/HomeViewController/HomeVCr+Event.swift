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
        // 달이 바뀔 때 요일 헤더 색상 재적용 (FSCalendar가 뷰를 갱신하므로 필요)
        (self as? HomeViewController)?.applyWeekdayHeaderColors()
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
        selectedDate = date // 선택된 날짜 저장
        
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 없음")
            return
        }

        // 현재 선택된 카테고리 키
        let selectedCategoryKey = homeView.eventView.selectedCategory?.serverKey
        
        eventViewModel.fetchEventsByDate(date, token: token, category: selectedCategoryKey) { result in
            switch result {
            case .success(let eventDates):
                let workItem = DispatchWorkItem {
                    let eventCategory = selectedCategoryKey ?? "OTHER"
                    let mappedEvents = eventDates.map { Event(id: $0.id, title: $0.title, category: eventCategory, done: $0.done) }
                    self.homeView.eventView.updateEvents(mappedEvents)
                    print("\(self.dateFormatter.string(from: date)) 일정 \(eventDates.count)건 불러옴 (카테고리: \(selectedCategoryKey ?? "전체"))")
                }
                DispatchQueue.main.async(execute: workItem)
            case .failure(let error):
                print("날짜별 일정 조회 실패: \(error)")
            }
        }
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: date)
            return markedDateStrings.contains(dateString) ? 1 : 0
    }

    // MARK: - Weekend colors (numbers): Sat blue, Sun red
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let weekday = Calendar.current.component(.weekday, from: date)
        // In Gregorian calendar: 1 = Sunday, 7 = Saturday
        if weekday == 1 { return .red00 }
        if weekday == 7 { return .blue01 }
        return .gray00
    }

    // MARK: Weekday header colors: Sun red, Sat blue, others gray
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, weekdayTextColorFor weekday: Int) -> UIColor? {
        // FSCalendar weekday: 1 = Sun, 7 = Sat
        if weekday == 1 { return .red00 }
        if weekday == 7 { return .blue01 }
        return .gray00
    }
}

extension HomeViewController: EditEventViewControllerDelegate {
    func didDeleteEvent(eventId: Int) {
        homeView.eventView.removeEvent(withId: eventId)
        // 달력 동그라미(이벤트 표시) 즉시 갱신
        fetchEventDatesForCurrentMonth() { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.homeView.calendarView.reloadData()
            }
        }
        // 현재 선택된 날짜의 일정 목록도 재조회하여 빈 상태 반영
        if let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty {
            eventViewModel.fetchEventsByDate(selectedDate, token: token) { [weak self] result in
                switch result {
                case .success(let eventDates):
                    DispatchQueue.main.async {
                        let mapped = eventDates.map { Event(id: $0.id, title: $0.title, category: "OTHER", done: $0.done) }
                        self?.homeView.eventView.updateEvents(mapped)
                    }
                case .failure:
                    break
                }
            }
        }
    }
    
    func didUpdateEvent(_ updatedEventId: Int) {
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 없음")
            return
        }

        eventViewModel.fetchEventsByDate(Date(), token: token) { result in
            switch result {
            case .success(let events):
                let workItem = DispatchWorkItem {
                    let mappedEvents = events.map {
                        Event(id: $0.id, title: $0.title, category: "GENERAL", done: $0.done)
                    }
                    self.homeView.eventView.updateEvents(mappedEvents)
                    print("수정 반영 후 일정 \(events.count)건 갱신 완료")
                }
                DispatchQueue.main.async(execute: workItem)
            case .failure(let error):
                print("수정 후 일정 재조회 실패: \(error)")
            }
        }
        // 월별 이벤트 점도 갱신
        fetchEventDatesForCurrentMonth() { [weak self] in
            self?.homeView.calendarView.reloadData()
        }
    }
}
