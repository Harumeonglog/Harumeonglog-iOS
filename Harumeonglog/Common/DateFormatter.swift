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
        DateFormatterShared.sharedFormatter.locale = Locale(identifier: "en_US_POSIX")
        DateFormatterShared.sharedFormatter.timeZone = TimeZone(secondsFromGMT: 0)  // UTC 기준

        return DateFormatterShared.sharedFormatter.date(from: dateString)
    }
    
}
