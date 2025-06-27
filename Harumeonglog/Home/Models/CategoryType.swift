//
//  CategoryType.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/14/25.
//

enum CategoryType: String, CaseIterable {
    case bath = "목욕"
    case walk = "산책"
    case medicine = "약"
    case checkup = "진료"
    case other = "기타"

    var displayName: String {
        return self.rawValue
    }

    var serverKey: String {
        switch self {
        case .bath: return "BATH"
        case .walk: return "WALK"
        case .medicine: return "MEDICINE"
        case .checkup: return "HOSPITAL"
        case .other: return "GENERAL"
        }
    }

    static func fromServerValue(_ serverValue: String) -> CategoryType? {
        switch serverValue {
        case "BATH": return .bath
        case "WALK": return .walk
        case "MEDICINE": return .medicine
        case "HOSPITAL": return .checkup
        case "GENERAL": return .other
        default: return nil
        }
    }

    static var allCasesWithAll: [CategoryType?] {
        return [nil] + CategoryType.allCases
    }
}
