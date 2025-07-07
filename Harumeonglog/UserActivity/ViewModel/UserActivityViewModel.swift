//
//  UserActivityViewModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import Combine
import Alamofire

final class UserActivityViewModel: ObservableObject {
    
    @Published var likedCursor: Int = 0
    @Published var likedPosts = [PostItem]()
    
    @Published var myPostsCursor: Int = 0
    @Published var myPosts = [PostItem]()
    
    var cancellables: Set<AnyCancellable> = []
    
    func getmyPosts() {
        UserActivityService.getmyPosts(cursor: myPostsCursor) { [weak self] result in
            switch result {
            case .success(let value):
                print("#getmyPosts success")
                self?.myPostsCursor = value.result?.cursor ?? 0
                self?.myPosts.append(contentsOf: value.result?.items ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getLikedPosts() {
        UserActivityService.getLikedPosts(cursor: myPostsCursor) { [weak self] result in
            switch result {
            case .success(let value):
                print("#getLikedPosts success")
                self?.likedCursor = value.result?.cursor ?? 0
                self?.likedPosts.append(contentsOf: value.result?.items ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
