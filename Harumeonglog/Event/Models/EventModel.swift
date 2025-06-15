//
//  EventModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/14/25.
//


//MARK: GET /api/v1/events/{eventId} 일정 단일 조회
struct EventDetailResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventDetailResult?
}

struct EventDetailResult: Decodable {
    let id: Int
    let title: String
    let date: String
    let isRepeated: Bool
    let repeatDays: [String]
    let expiredDate: String?
    let hasNotice: Bool
    let category: String
    let time: String
    let updatedAt: String
    let hospitalName: String?
    let department: String?
    let cost: Int?
    let details: String?
    let medicineName: String?
    let distance: String?
    let duration: String?
}

//MARK: DELETE /api/v1/events/{eventId} 일정 삭제
struct EventDeleteResponse : Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}

//MARK: PATCH /api/v1/events/{eventId} 일정 체크
struct EventCheckResponse : Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventCheck?
}

struct EventCheck: Decodable {
    let id: Int
    let title: String
    let done: Bool
}


//MARK: PUT /api/v1/events/{eventId} 일정 수정

struct EventTimeRequest: Codable {
    let hour: Int
    let minute: Int
    let second: Int
    let nano: Int
}

struct EventRequest: Codable {
    var title: String
    var date: String
    var isRepeated: Bool
    var expiredDate: String
    var repeatDays: [String]
    var hasNotice: Bool
    var time: String
    var category: String
    var details: String?
    var hospitalName: String?
    var department: String?
    var cost: Int?
    var medicineName: String?
    var distance: String?
    var duration: String?
}

struct EventUpdateResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UpdatedEvent?
}
struct UpdatedEvent: Decodable {
    let id: Int
    let title: String
    let date: String
    let isRepeated: Bool
    let repeatDays: [String]
    let expiredDate: String?
    let hasNotice: Bool
    let category: String
    let time: String
    let updatedAt: String
    let hospitalName: String?
    let department: String?
    let cost: Int?
    let details: String?
    let medicineName: String?
    let distance: String?
    let duration: String?
}


//MARK: GET /api/v1/events/monthly-dates 한달에 일정 있는 날 조회
struct EventResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventResult?
}
struct EventResult: Decodable {
    let dates: [String]
}


//MARK: POST /api/v1/events 일정 추가

struct EventCreateResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventCreateResult?
}
struct EventCreateResult: Decodable {
    let eventId: Int?
    let createdAt: String?
    let updatedAt: String?
}

//MARK: GET /api/v1/events 날짜별 일정 조회
struct EventDateResponse : Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventDateResult?
}


struct EventDateResult: Decodable {
    let events: [EventDate]?
    let cursor: Int?
    let hasNext: Bool
}


struct EventDate: Decodable{
    let id: Int
    let title: String
    let done: Bool
}

struct Event {
    let id: Int
    let title: String
    let category: String
    let done: Bool
}
