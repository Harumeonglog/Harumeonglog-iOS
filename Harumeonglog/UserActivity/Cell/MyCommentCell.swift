//
//  MyCommentCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import UIKit

class MyCommentCell: UITableViewCell {
    
    static let identifier: String = "MyCommentCell"
    private var comment: MyCommentItem?
    
    func configure(comment: MyCommentItem) {
        self.comment = comment
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
