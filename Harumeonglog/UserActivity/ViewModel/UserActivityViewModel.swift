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
    private var likedHasNext: Bool = true
    
    @Published var myPostsCursor: Int = 0
    @Published var myPosts = [PostItem]()
    private var myPostsHasNext: Bool = true
    
    @Published var myCommentCursor: Int = 0
    @Published var myComments = [MyCommentItem]()
    private var myCommentsHasNext: Bool = true
    
    var cancellables: Set<AnyCancellable> = []
    
    func getmyPosts() {
        guard myPostsHasNext else { print("#getmyPosts hasNext false"); return }
        UserActivityService.getmyPosts(cursor: myPostsCursor) { [weak self] result in
            switch result {
            case .success(let value):
                print("#getmyPosts success")
                self?.myPostsCursor = value.result?.cursor ?? 0
                self?.myPosts.append(contentsOf: value.result?.items ?? [])
                self?.myPostsHasNext = value.result?.hasNext ?? false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getLikedPosts() {
        guard likedHasNext else { print("#getmyPosts hasNext false"); return }
        UserActivityService.getLikedPosts(cursor: myPostsCursor) { [weak self] result in
            switch result {
            case .success(let value):
                print("#getLikedPosts success")
                self?.likedCursor = value.result?.cursor ?? 0
                self?.likedPosts.append(contentsOf: value.result?.items ?? [])
                self?.likedHasNext = value.result?.hasNext ?? false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMyComments() {
        guard myCommentsHasNext else { print("#getMyComments hasNext false"); return }
        UserActivityService.getMyComments(cursor: myCommentCursor) { [weak self] result in
            switch result {
            case .success(let value):
                print("#getMyComments success")
                print(value.result?.items)
                self?.myCommentCursor = value.result?.cursor ?? 0
                self?.myComments.append(contentsOf: value.result?.items ?? [])
                self?.myCommentsHasNext = value.result?.hasNext ?? false
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
