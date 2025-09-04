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
    
    func toKoreanWeekdays() -> [String] {
        let weekdayMap: [String: String] = [
            "MON": "월", "TUE": "화", "WED": "수", "THU": "목",
            "FRI": "금", "SAT": "토", "SUN": "일"
        ]
        return self.compactMap{(weekdayMap[$0])}
    }
}

public extension Sequence where Element == String {
    func mappedToKoreanWeekdays() -> Set<String> {
        let englishToKorean: [String: String] = [
            "MON": "월", "TUE": "화", "WED": "수", "THU": "목",
            "FRI": "금", "SAT": "토", "SUN": "일",
            "MONDAY": "월", "TUESDAY": "화", "WEDNESDAY": "수", "THURSDAY": "목",
            "FRIDAY": "금", "SATURDAY": "토", "SUNDAY": "일"
        ]
        let koreanSet: Set<String> = ["월","화","수","목","금","토","일"]
        var result = Set<String>()
        for raw in self {
            let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            let upper = trimmed.uppercased()
            if let mapped = englishToKorean[upper] {
                result.insert(mapped)
            } else if koreanSet.contains(trimmed) {
                result.insert(trimmed)
            }
        }
        return result
    }
}
