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
    
    @Published var myCommentCursor: Int = 0
    @Published var myComments = [MyCommentItem]()
    
    var cancellables: Set<AnyCancellable> = []
    
    func getmyPosts() {
        UserActivityService.getMyPosts(cursor: myPostsCursor) { [weak self] result in
            switch result {
            case .success(let response):
                print("#getMyPosts success")
                guard let reuslt = response.result else { print("Result is nil"); return }
                guard !response.result!.items.isEmpty else { print("Empty"); return }
                self?.myPostsCursor = response.result!.items.last?.postId ?? -1
                self?.myPosts.append(contentsOf: response.result?.items ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getLikedPosts() {
        UserActivityService.getLikedPosts(cursor: likedCursor) { [weak self] result in
            switch result {
            case .success(let response):
                print("#getLikedPosts success")
                guard let _ = response.result else { print("Result is nil"); return }
                guard !response.result!.items.isEmpty else { print("Empty"); return }
                self?.likedCursor = response.result?.items.last?.postId ?? -1
                self?.likedPosts.append(contentsOf: response.result?.items ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMyComments() {
        UserActivityService.getMyComments(cursor: myCommentCursor) { [weak self] result in
            switch result {
            case .success(let response):
                print("#getMyComments success")
                guard let _ = response.result else { print("Result is nil"); return }
                guard !response.result!.items.isEmpty else { print("Empty"); return }
                self?.myCommentCursor = response.result?.items.last?.commentId ?? -1
                self?.myComments.append(contentsOf: response.result?.items ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
