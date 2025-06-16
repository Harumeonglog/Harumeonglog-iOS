//
//  Set+Weekdays.swift
//  Harumeonglog
//
//  Created by Dana Lim on 6/16/25.
//
import Foundation

extension Set where Element == String {
    func toEnglishWeekdays() -> [String] {
        let weekdayMap: [String: String] = [
            "월": "MON", "화": "TUE", "수": "WED", "목": "THU",
            "금": "FRI", "토": "SAT", "일": "SUN"
        ]
        return self.compactMap { weekdayMap[$0] }
    }
}
