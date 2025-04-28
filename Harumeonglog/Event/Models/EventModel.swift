//
//  EventModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/14/25.
//

//MARK: GET /events/{eventId} 일정 상세 조회
//response
struct EventDetailResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [EventDetail]
}

struct EventDetail: Codable {
    let id: Int
    let title: String
    let date: String
    let isRepeated: Bool
    let expiredDate: String
    let hasNotice: Bool
    let category: String
}

//MARK: DELETE /events/{eventId} 일정 삭제
//response
struct BaseStringResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

//MARK: PATCH /events/{eventId} 일정 완료
//response
struct EventPatchResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventIDResult
}

struct EventIDResult: Codable {
    let eventId: Int
}

//MARK: PUT /events/{eventId} 일정 수정
// Request: EventWriteRequest
// Response: EventDetailResponse

//MARK: GET /events 날짜별 일정 조회
//response
struct EventListResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [DailyEventGroup]?
}

struct DailyEventGroup: Decodable {
    let events: [Event]?
}

struct Event: Decodable {
    let id: Int
    let title: String
    let done: Bool
    let category: String
}

//MARK: POST /events 일정 등록
//request
struct EventWriteRequest: Codable {
    var title: String
    var date: String
    var isRepeated: String
    var expiredDate: String
    var hasNotice: Bool
    var category: Bool
    var details: String
    var hospitalName: String
    var department: String
    var cost: Int
    var medicineName:String
    var distance: String
    var duration: String
}
//response
struct EventPostResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventIDResult
}


struct EmptyRequest: Encodable {}
