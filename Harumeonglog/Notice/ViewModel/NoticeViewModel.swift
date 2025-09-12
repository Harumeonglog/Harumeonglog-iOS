//
//  NoticeViewModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 6/18/25.
//

import Combine
import Alamofire

final class NoticeViewModel: ObservableObject {
    
    @Published var noticeList: [NoticeModel] = []
    @Published var isLoading: Bool = false
    var cursor: Int? = 0
    
    init() {}
    
    func getNotices() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { print("엑세스 토큰이 없음"); return}
        guard !isLoading else { print("isLoading true"); return }
        isLoading = true
        NoticeService.getNoticies(cursor: cursor!, token: token) { result in
            switch result {
            case .success(let response):
                print("알림 불러오기 성공")
                print(response.result?.items as Any)
                if let result = response.result {
                    self.noticeList.append(contentsOf: result.items ?? [])
                    self.noticeList.sort{ $0.noticeId ?? 1 > $1.noticeId ?? 2 }
                    self.cursor = self.noticeList.last?.noticeId
                }
            case .failure(let failure):
                print("알림 불러오기 실패: \(failure)")
            }
            self.isLoading = false
        }
    }
    
    func deleteNotice(id: Int, completion: @escaping(Result<HaruResponse<HaruEmptyResult>, AFError>) -> Void) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { print("엑세스 토큰이 없음"); return}
        NoticeService.deletePet(noticeID: id, token: token) { result in
            switch result {
            case .success(let response):
                print("알림 삭제 성공")
                if let _ = response.result {
                    self.noticeList.removeAll{ $0.noticeId  == id }
                }
                completion(result)
            case .failure(let failure):
                print("알림 삭제 실패: \(failure)")
                completion(result)
            }
        }
    }
    
}
