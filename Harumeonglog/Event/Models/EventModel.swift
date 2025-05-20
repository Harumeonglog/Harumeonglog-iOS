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
    let result: EventDetail
}

struct EventDetail: Decodable {
    let id: Int
    let title: String
    let date: String
    let isRepeated: Bool
    let repeatDays: [String]
    let expiredDate: String
    let hasNotice: Bool
    let category: String
    let time: EventTime
    let updatedAt: String
}

struct EventTime: Codable {
    let hour: Int
    let minute: Int
    let second: Int
    let nano: Int
}

//MARK: DELETE /api/v1/events/{eventId} 일정 삭제
struct EventDeleteResponse : Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

//MARK: PATCH /api/v1/events/{eventId} 일정 체크
struct EventCheckResponse : Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventCheck
}

struct EventCheck: Decodable {
    let id: Int
    let title: String
    let done: Bool
}


//MARK: PUT /api/v1/events/{eventId} 일정 수정
struct EventUpdateRequest: Codable {
    let title: String
    let date: String
    let isRepeated: Bool
    let expiredDate: String
    let repeatDays: [String]
    let hasNotice: Bool
    let time: EventTime
    let category: String
    let details: String
    let hospitalName: String
    let department: String
    let cost: Int
    let medicineName: String
    let distance: String
    let duration: String
}

struct EventUpdateResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UpdatedEvent
}
struct UpdatedEvent: Decodable {
    let id: Int
    let title: String
    let date: String
    let isRepeated: Bool
    let repeatDays: [String]
    let expiredDate: String
    let hasNotice: Bool
    let category: String
    let time: EventTime
    let updatedAt: String
}


//MARK: GET /api/v1/events/monthly-dates 한달에 일정 있는 날 조회
struct EventResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventResult
}
struct EventResult: Decodable {
    let dates: [String]
}


//MARK: POST /api/v1/events 일정 추가
struct EventCreateRequest: Codable {
    let title: String
    let date: String
    let isRepeated: Bool
    let expiredDate: String
    let repeateDays: [String]
    let hasNotice: Bool
    let time: String
    let category: String
    let hospitalName: String
    let department: String
    let cost: Int
    let details: String
}

struct EventCreateResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventCreateResult
}
struct EventCreateResult: Decodable {
    let eventId: Int
    let createdAt: String
    let updatedAt: String
}
