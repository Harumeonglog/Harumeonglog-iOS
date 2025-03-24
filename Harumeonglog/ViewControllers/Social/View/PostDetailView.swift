//
//  PostDetailView.swift.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/23/25.
//

import UIKit
import SnapKit
import Then

class PostDetailView: UIView {
    
    public lazy var accountImageView = UIImageView().then { imageView in
    }
    
    public lazy var accountName = UILabel().then { label in
    }
    
    public lazy var postCategory = UILabel().then { label in
    }
    
    public lazy var postSetting = UIImageView().then { imageView in
    }
    
    public lazy var postTitle = UILabel().then { label in
    }
    
    public lazy var postContent = UILabel().then { label in
    }
    
    public lazy var postImageView = UIImageView().then { imageView in
    }
    
    public lazy var likeImageView = UIImageView().then { imageView in
    }
    
    public lazy var likeCount = UILabel().then { label in
    }
    
    private lazy var commentImageView = UIImageView().then { imageView in
    }
    
    public lazy var commentCount = UILabel().then { label in
    }
    
    public lazy var postTimeLabel = UILabel().then { label in
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        
    }
}
