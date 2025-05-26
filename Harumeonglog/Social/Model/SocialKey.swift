//
//  socialKey.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/26/25.
//

import Foundation
import UIKit

// 커뮤니티 카테고리
struct socialCategoryKey {
    static let tags = ["정보 공유", "유머", "Q&A", "SNS", "기타"]
    
    static let tagsKortoEng: [String: String] = [
        "정보 공유": "INFO",
        "유머": "HUMOR",
        "Q&A": "QNA",
        "SNS": "SNS",
        "기타": "ETC"
    ]
    
    static let tagsEngKorto: [String: String] = [
        "INFO": "정보 공유",
        "HUMOR": "유머",
        "QNA": "Q&A",
        "SNS": "SNS",
        "ETC": "기타"
    ]
}
