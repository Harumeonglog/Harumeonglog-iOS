//
//  ImageCell.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/28/25.
//

import UIKit
import SnapKit
import Then

class AddImageViewCell: UICollectionViewCell {
    
    static let identifier = "AddImageViewCell"
    
    // 삭제 이벤트 전달용 클로저
    var onDelete: (() -> Void)?
    
    public lazy var imageView = UIImageView().then { imageView in
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
    }
    
    public lazy var deleteButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteButtonTapped() {
        print("삭제버튼 눌림")
        onDelete?()
    }
    
    private func addComponents() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
        }
    }
}
