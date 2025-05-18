//
//  SocialView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/20/25.
//

import UIKit
import SnapKit
import Then

class SocialView: UIView {
    public var itemButtons: [UIButton] = []

    public lazy var searchBar = UITextField().then { textfield in
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.brown02.cgColor
        textfield.textColor = .gray01
        textfield.font = UIFont(name: "Pretendard-Medium", size: 14)
        textfield.layer.cornerRadius = 20
        textfield.backgroundColor = .white
        textfield.clipsToBounds = true
        
        // 왼쪽 여백을 포함한 StackView 생성
        let leftpaddingView = UIView().then { make in
            make.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
        let searchIcon = searchButton
        let paddingView = UIView().then { make in
            make.widthAnchor.constraint(equalToConstant: 5).isActive = true
        }

        let leftStackView = UIStackView(arrangedSubviews: [leftpaddingView, searchIcon, paddingView]).then { make in
            make.axis = .horizontal
            make.spacing = 5
            make.alignment = .center
            make.frame = CGRect(x: 0, y: 0, width: 50, height: 17)
        }

        textfield.leftView = leftStackView
        textfield.leftViewMode = .always

        // 오른쪽 x 버튼 설정
        let cancelButton = searchCancelButton
        let rightpaddingView = UIView().then { make in
            make.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        let rightStackView = UIStackView(arrangedSubviews: [cancelButton, rightpaddingView]).then { make in
            make.axis = .horizontal
            make.spacing = 5
            make.alignment = .center
            make.frame = CGRect(x: 0, y: 0, width: 50, height: 17)
        }
        
        textfield.rightView = rightStackView
        textfield.rightViewMode = .always
    }
    
    public lazy var searchButton = UIButton().then { button in
        button.tintColor = .gray01
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
    }
    
    public lazy var searchCancelButton = UIButton().then { button in
        button.tintColor = .gray01
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        button.isHidden = true
    }
    
    public lazy var categoryButtonsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.bouncesVertically = false
        return scrollView
    }()
    
    public lazy var categoryButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    public lazy var postTableView = UITableView().then { tableView in
        tableView.register(ImageViewCell.self, forCellReuseIdentifier: "ImageViewCell")
        tableView.register(TextOnlyCell.self, forCellReuseIdentifier: "TextOnlyCell")
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
    }
    
    public lazy var addPostButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular), forImageIn: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue01
        button.layer.cornerRadius = 30
        button.isUserInteractionEnabled = true
    }
    
    private lazy var bottomLineView = UIView().then  { view in
        view.backgroundColor = UIColor.gray04
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addComponents() {
        
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(80)
            make.height.equalTo(40)
        }
        
        self.addSubview(categoryButtonsScrollView)
        categoryButtonsScrollView.addSubview(categoryButtonsStackView)
        
        categoryButtonsScrollView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(29)
        }
    
        categoryButtonsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        createButtons()

        self.addSubview(postTableView)
        
        postTableView.snp.makeConstraints { make in
            make.top.equalTo(categoryButtonsScrollView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.addSubview(addPostButton)
        
        addPostButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(60)
        }
        
        self.addSubview(bottomLineView)
        
        bottomLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func createButtons() {
        var num = 1
        for tag in socialCategoryKey.tags {
            let button = UIButton(type: .system)
            button.backgroundColor = .brown02
            button.setTitle(tag, for: .normal)
            button.titleLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "Pretendard-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13))
            button.layer.cornerRadius = 15
            button.tintColor = .gray00
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 21, bottom: 8, right: 21)
            button.frame = CGRect(x: 0, y: 0, width: 70, height: 29)
            button.tag = num

            num += 1
            itemButtons.append(button)
            categoryButtonsStackView.addArrangedSubview(button)
        }
    }
    
    public func forEachButton(_ action: (UIButton) -> Void) {
        categoryButtonsStackView.arrangedSubviews.compactMap { $0 as? UIButton }.forEach(action)
    }
    
    
    
}
