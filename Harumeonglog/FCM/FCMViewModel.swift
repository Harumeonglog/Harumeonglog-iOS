//
//  FileViewModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/27/25.
//

import Alamofire

final class FCMViewModel {
    
    func sendFCM(fcm: String) {
        FCMService.sendFCM(fcm: fcm) { result in
            switch result {
            case .success(_):
                print("FCM 등록 성공 \(fcm)")
                return
            case .failure(let error):
                print("FCM 등록 실패 \(error)")
                return
            }
        }
    }
    
}
