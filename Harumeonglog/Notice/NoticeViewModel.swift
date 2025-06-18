//
//  NoticeViewModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/18/25.
//

import Combine
import Alamofire

final class NoticeViewModel: ObservableObject {
    
    @Published var notices: [NoticeModel] = []
    @Published var isLoading: Bool = false
    
    
    
}
