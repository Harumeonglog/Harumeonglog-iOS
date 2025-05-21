//
//  ScheduleService.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/14/25.
//
import Alamofire

enum EventService {
    
    //MARK: GET /api/v1/events/{eventId} 일정 단일 조회
    static func getEventDetail(eventId: Int, token: String? = nil, completion: @escaping (Result<EventDetailResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/events/\(eventId)"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }

    //MARK: DELETE /api/v1/events/{eventId} 일정 삭제
    static func deleteEvent(eventId: Int, token: String? = nil, completion: @escaping (Result<EventDeleteResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/events/\(eventId)"
        APIClient.deleteRequest(endpoint: endpoint, token: token, completion: completion)
    }

    //MARK: PATCH /api/v1/events/{eventId} 일정 체크
    static func checkEvent(eventId: Int, token: String? = nil, completion: @escaping (Result<EventCheckResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/events/\(eventId)"
        APIClient.patchRequest(endpoint: endpoint, token: token, completion: completion)
    }

    //MARK: PUT /api/v1/events/{eventId} 일정 수정
    static func updateEvent(eventId: Int, request: EventRequest, token: String, completion:@escaping (Result<EventUpdateResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/events/\(eventId)"
        APIClient.putRequest(endpoint: endpoint, encodable: request, token: token, completion: completion)
    }

    //MARK: GET /api/v1/events/monthly-dates 한달에 일정 있는 날 조회
        static func getEvents(year: Int, month: Int, token: String? = nil, completion: @escaping (Result<EventResponse, AFError>) -> Void) {
            let endpoint = "/api/v1/events/monthly-dates"
            let parameters: [String: Any] = ["year": year, "month": month]
            APIClient.getRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
        }

    //MARK: POST /api/v1/events 일정 추가
    static func createEvent(request: EventRequest, token: String? = nil, completion: @escaping (Result<EventCreateResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/events"
        APIClient.postRequest(endpoint: endpoint, parameters: request, token: token, completion: completion)
    }
    
    //MARK: GET /api/v1/events 날짜별 일정 조회
    static func getEventsByDate(date: String, category: String? = nil, token: String? = nil, completion: @escaping (Result<EventDateResponse, AFError>) -> Void) {
        let endpoint = "/api/v1/events"
        var parameters: [String: Any] = [
            "date": date,
            "cursor": 0,
            "size": 10
        ]
        if let category = category {
            parameters["category"] = category
        }
        APIClient.getRequest(endpoint: endpoint, parameters: parameters, token: token, completion: completion)
    }

}
