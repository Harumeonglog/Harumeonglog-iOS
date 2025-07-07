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
