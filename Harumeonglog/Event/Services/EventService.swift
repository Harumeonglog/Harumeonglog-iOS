//
//  ScheduleService.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/14/25.
//
import Alamofire

enum EventService {
    
    //MARK: GET /events/{eventId} 일정 상세 조회
    static func getEventDetail(eventId: Int, token: String? = nil, completion: @escaping (Result<EventDetailResponse, AFError>) -> Void) {
        let endpoint = "/events/\(eventId)"
        APIClient.getRequest(endpoint: endpoint, token: token, completion: completion)
    }

    //MARK: DELETE /events/{eventId} 일정 삭제
    static func deleteEvent(eventId: Int, token: String? = nil, completion:@escaping (Result<BaseStringResponse, AFError>) -> Void) {
        let endpoint = "/events/\(eventId)"
        APIClient.deleteRequest(endpoint: endpoint, token: token, completion: completion)
    }

    //MARK: PATCH /events/{eventId} 일정 완료
    static func completeEvent(eventId: Int, token: String? = nil, completion:@escaping (Result<EventPatchResponse, AFError>) -> Void) {
        let endpoint = "/events/\(eventId)"
        let empty = EmptyRequest()
        APIClient.patchRequest(endpoint: endpoint, parameters: empty, token: token, completion: completion)
    }

    //MARK: PUT /events/{eventId} 일정 수정
    static func updateEvent(eventId: Int, token: String? = nil, completion:@escaping (Result<EventPatchResponse, AFError>) -> Void) {
        
    }

    //MARK: GET /events 날짜별 일정 조회
    static func getEvents() -> Void {
        
    }

    //MARK: POST /events 일정 등록
    static func createEvent() -> Void {
        
    }

}
