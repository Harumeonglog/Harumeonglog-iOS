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
        let koreanFullToShort: [String: String] = [
            "월요일": "월", "화요일": "화", "수요일": "수", "목요일": "목",
            "금요일": "금", "토요일": "토", "일요일": "일"
        ]
        let koreanSet: Set<String> = ["월","화","수","목","금","토","일"]
        var result = Set<String>()
        for raw in self {
            // 공백/문장부호 제거
            let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: ",.;:"))
            var upper = trimmed.uppercased()
            // 흔한 약어 변형 보정: TUES, WEDS, THURS -> TUE, WED, THU
            if upper == "TUES" { upper = "TUE" }
            if upper == "WEDS" { upper = "WED" }
            if upper == "THURS" { upper = "THU" }
            if let mapped = englishToKorean[upper] {
                result.insert(mapped)
            } else if koreanSet.contains(trimmed) {
                result.insert(trimmed)
            } else if let mappedKr = koreanFullToShort[trimmed] {
                result.insert(mappedKr)
            }
        }
        return result
    }
}
