//
//  SocialPostService.swift
//  Harumeonglog
//
//  Created by 김민지 on 4/30/25.
//

import Foundation
import Alamofire

// Post 관련 API
class SocialPostService {
    
    func postPostToServer(title: String, postCategory: String, content: String, postImageList: [URL], completion: @escaping (Bool) -> Void) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        let parameters = postSocialRequest(postCategory: postCategory, title: title, content: content, postImageList: postImageList)
        
        print("\(parameters)")
        APIClient.postRequest(endpoint: "/", parameters: parameters, token: token) { (result :  Result<HaruResponse<postSocialResponse>, AFError>) in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("Successfully posted")

                    if let result = response.result {
                        print("postID: \(result.postId)")
                    }
                } else {
                    print("Response 실패: \(response.message)")
                }
            case .failure(let error):
                print("Failed to posted : \(error.localizedDescription)")
            }
            
        }
    }
}
