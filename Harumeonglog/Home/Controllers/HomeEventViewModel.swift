//
//  HomeEventViewModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
// API 요청 및 날짜/이벤트 가공


import Foundation
import Alamofire

class HomeEventViewModel {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func fetchEventDates(year: Int, month: Int, token: String, completion: @escaping (Result<EventResponse, AFError>) -> Void) {
        EventService.getEvents(year: year, month: month, token: token) { result in
            completion(result)
        }
    }

    func fetchEventsByDate(_ date: Date, token: String, completion: @escaping (Result<[EventDate], AFError>) -> Void) {
        let selectedDate = dateFormatter.string(from: date)
        EventService.getEventsByDate(date: selectedDate, token: token) { result in
            switch result {
            case .success(let response):
                let events = response.result?.events ?? []
                completion(.success(events))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
