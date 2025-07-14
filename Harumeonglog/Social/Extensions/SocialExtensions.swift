//
//  SocialExtensions.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/24/25.
//

import UIKit

extension UIView {
    func timeAgoString(from createdAt: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(createdAt)

        let minute = 60.0
        let hour = 60.0 * minute
        let day = 24.0 * hour
        let month = 30.0 * day
        let year = 12.0 * month

        switch interval {
        case 0..<minute:
            return "\(Int(interval))초 전"
        case minute..<hour:
            return "\(Int(interval / minute))분 전"
        case hour..<day:
            return "\(Int(interval / hour))시간 전"
        case day..<month:
            return "\(Int(interval / day))일 전"
        case month..<year:
            return "\(Int(interval / month))개월 전"
        default:
            return "\(Int(interval / year))년 전"
        }
    }

    
    func timeAgoString(from createdAtString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 9 * 3600) // KST 기준으로 파싱

        guard let createdAt = formatter.date(from: createdAtString) else {
            return "알 수 없음"
        }

        let now = Date()
        let interval = now.timeIntervalSince(createdAt)

        if interval < 60 {
            return "\(Int(interval))초 전"
        } else if interval < 3600 {
            return "\(Int(interval / 60))분 전"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))시간 전"
        } else {
            return "\(Int(interval / 86400))일 전"
        }
    }
}
