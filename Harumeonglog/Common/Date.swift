//
//  Date.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/19/25.
//

import Foundation

extension DateFormatter {
    
    static let formatter = ISO8601DateFormatter()
    
    static func stringToString(from string: String) -> String {
        if let date = date(from: string) {
            return timeAgoString(from: date)
        } else {
            return "null date"
        }
    }
    
    static func date(from string: String?) -> Date? {
        guard let string = string else { return nil }
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string)
    }

    static func timeAgoString(from date: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: date, to: now)
        
        if let year = components.year, year >= 1 {
            return "\(year)년 전"
        }
        
        if let month = components.month, month >= 1 {
            return "\(month)달 전"
        }

        if let week = components.weekOfYear, week >= 1 {
            return "\(week)주 전"
        }

        if let day = components.day, day >= 1 {
            return "\(day)일 전"
        }

        if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 전"
        }

        if let minute = components.minute {
            switch minute {
            case 0..<1:
                return "방금 전"
            case 1..<10:
                return "\(minute)분 전"
            case 10..<60:
                let rounded = (minute / 10) * 10
                return "\(rounded)분 전"
            default:
                return "\(minute)분 전"
            }
        }
        
        return "방금 전"
    }
}
