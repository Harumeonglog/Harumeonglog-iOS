//
//  PhotoDetailView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//
import UIKit
import SnapKit

class PhotoDetailView: UIView {
    private let imageView: UIImageView
    
    public lazy var navigationBar = CustomNavigationBar()

    init(image: UIImage, album: Album) {
        self.imageView = UIImageView(image: image)
        super.init(frame: .zero)
        backgroundColor = .background
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let bottomActionBar : UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray04.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .bg
        return view
    }()
    
    let downloadButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down.to.line.compact"), for: .normal)
        button.tintColor = .gray00
        return button
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .gray00
        return button
    }()

    private func setupView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(navigationBar)
        addSubview(bottomActionBar)
        bottomActionBar.addSubview(downloadButton)
        bottomActionBar.addSubview(deleteButton)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(imageView.snp.width)
        }
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        bottomActionBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(87)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(33)
            make.bottom.equalToSuperview().inset(37)
            make.width.height.equalTo(24)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(33)
            make.centerY.equalTo(downloadButton)
            make.width.height.equalTo(24)
        }
    }
}
