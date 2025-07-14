//
//  DateFormatter.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/8/25.
//

import Foundation

class DateFormatterShared {
    
    static let sharedFormatter = DateFormatter()
    
    static func convertISO8601StringToDate(_ dateString: String) -> Date? {
        DateFormatterShared.sharedFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        DateFormatterShared.sharedFormatter.locale = Locale(identifier: "ko_KR")
            DateFormatterShared.sharedFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")  // 한국 시간

        return DateFormatterShared.sharedFormatter.date(from: dateString)
    }
    
    static func convertStringToDate(_ dateString: String, format: String) -> Date? {
        DateFormatterShared.sharedFormatter.dateFormat = format
        DateFormatterShared.sharedFormatter.locale = Locale(identifier: "ko_KR")
        DateFormatterShared.sharedFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")  // 한국 시간

        return DateFormatterShared.sharedFormatter.date(from: dateString)
    }
    
}
