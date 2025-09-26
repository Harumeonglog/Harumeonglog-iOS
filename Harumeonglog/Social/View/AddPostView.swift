//
//  AddPostView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/27/25.
//

import UIKit
import SnapKit
import Then

class AddPostView: UIView, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: CategorySelectionDelegate?
    
    private let categories = socialCategoryKey.tags
    public lazy var navigationBar = CustomNavigationBar()

    public lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "게시글 제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray02]
        )
        textField.font = .body
        textField.textColor = .gray00
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 15
        textField.layer.borderColor = UIColor.brown02.cgColor
        textField.layer.borderWidth = 1.0
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    
    public lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.brown02.cgColor
        button.layer.borderWidth = 1.0
        
        button.setTitle("카테고리 선택", for: .normal)
        button.setTitleColor(.gray00, for: .normal)
        button.titleLabel?.font = .body
        
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)

        let iconImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        iconImageView.tintColor = .gray02
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(iconImageView)

        // 아이콘 위치 설정 (버튼의 오른쪽 끝에서 25px 떨어지도록 고정)
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -25),
            iconImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18)
        ])

        button.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        return button
    }()
    
    //카테고리 드롭다운 리스트
    public lazy var dropdownTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.borderColor = UIColor.brown02.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 15
        return tableView
    }()
    
    public lazy var contentTextViewPlaceHolderLabel = UILabel().then { label in
        label.text = "부적절하거나 불쾌감을 줄 수 있는 글은 제재를 받을 수 있습니다."
        label.textColor = .gray02
        label.font = .body
        label.setLineSpacing(lineSpacing: 4)
        label.numberOfLines = 1
    }
    
    public lazy var contentTextView = UITextView().then { textView in
        textView.font = .body
        textView.textColor = .gray00
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 15
        textView.layer.borderColor = UIColor.brown02.cgColor
        textView.layer.borderWidth = 1.0
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.isScrollEnabled = true
    }
    
    public lazy var addImageButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .gray02
        button.backgroundColor = UIColor.brown02
        button.layer.cornerRadius = 15
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .medium), forImageIn: .normal)
        button.isUserInteractionEnabled = true
    }
    
    public lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then { layout in
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
    }).then { collectionView in
        collectionView.register(AddImageViewCell.self, forCellWithReuseIdentifier: "AddImageViewCell")
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
    }
    
    public lazy var addImageCount = UILabel().then { label in
        // label.text = "4/10"
        label.textColor = .gray02
        label.textAlignment = .center
        label.font = UIFont.body
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.addSubview(titleTextField)
        self.addSubview(categoryButton)
        self.addSubview(dropdownTableView)
        self.addSubview(contentTextView)
        contentTextView.addSubview(contentTextViewPlaceHolderLabel)
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.height.width.equalTo(titleTextField)
            make.centerX.equalToSuperview()
        }
        
        dropdownTableView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(20)
            make.width.equalTo(titleTextField)
            make.height.lessThanOrEqualTo(340)
            make.height.greaterThanOrEqualTo(120)
            make.centerX.equalToSuperview()
        }
        
        contentTextViewPlaceHolderLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.top).inset(contentTextView.textContainerInset.top)
            make.leading.equalTo(contentTextView.snp.leading).inset(contentTextView.textContainerInset.left + 3)
            make.trailing.equalTo(contentTextView.snp.trailing).inset(contentTextView.textContainerInset.right + 3)
        }
        
        self.addSubview(addImageButton)
        self.addSubview(imageCollectionView)
        self.addSubview(addImageCount)
        
        addImageButton.snp.makeConstraints { make in
            make.leading.equalTo(contentTextView)
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.width.height.equalTo(100)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(addImageButton)
            make.leading.equalTo(addImageButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        addImageCount.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.greaterThanOrEqualToSuperview().inset(44)
        }
    
        
    }
    
    @objc private func toggleDropdown() {
        dropdownTableView.isHidden.toggle()
        self.bringSubviewToFront(dropdownTableView)

    }

    // UITableView DataSource & Delegate
    //테이블뷰 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    //셀 구성하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell") ?? UITableViewCell(style: .default, reuseIdentifier: "DropdownCell")
        cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = .body
        cell.textLabel?.textColor = UIColor.gray01


        return cell
    }
    //셀 선택시 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
                cell.backgroundColor = .white  // 선택된 셀의 배경색을 하얀색으로 유지
            }

        let selectedCategory = categories[indexPath.row]
        categoryButton.setTitle("\(selectedCategory)", for: .normal)
        categoryButton.setTitleColor(.gray00, for: .normal)
        dropdownTableView.isHidden = true
        
        delegate?.didSelectCategory(selectedCategory)
    }
    
    
    func configure(with postDetail: PostDetailResponse) {
        titleTextField.text = postDetail.title
        categoryButton.setTitle(socialCategoryKey.tagsEngKorto[postDetail.postCategory]!, for: .normal)
        contentTextView.text = postDetail.content
        addImageCount.text = "\(postDetail.postImageList.count) / 10"
    
    }

}
