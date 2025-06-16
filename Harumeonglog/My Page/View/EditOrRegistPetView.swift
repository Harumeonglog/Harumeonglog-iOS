//
//  PuppyRegistration.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/17/25.
//

import UIKit
import SnapKit
import Then

class EditOrRegistPetView: UIView {
    
    public var selectedDogSize: DogSizeEnum?
    public var selectedDogGender: DogGenderEnum?
    public var petInfo: Pet?
    public var birthday: Date?
    private let labelLeadingPadding: CGFloat = 41
    private let leadingTrailingPadding: CGFloat = 28
    private let stackSpacing: CGFloat = 20
    
    public let navigationBar = CustomNavigationBar()
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    private lazy var contentView = UIView()
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        $0.backgroundColor = .gray01
    }
    
    public lazy var cameraButton = UIButton().then {
        $0.setImage(.camera, for: .normal)
    }
    
    private lazy var petNameLabel = commonLabel(text: "반려견 이름")
    public lazy var petNameTextField = UITextField.commonTextField()
    
    private lazy var selectPetSizeLabel = commonLabel(text: "반려견 크기")
    private lazy var petSizeStackView = UIStackView().then {
        $0.spacing = stackSpacing
    }
    
    public lazy var smallPetSizeButton = DogSizeButton(.SMALL)
    public lazy var middlePetSizeButton = DogSizeButton(.MEDIUM)
    public lazy var bigPetSizeButton = DogSizeButton(.BIG)
    
    private lazy var dogTypeLabel = commonLabel(text: "견종")
    public lazy var dogTypeTextField = UITextField.commonTextField()
    
    private lazy var dogGenderLabel = commonLabel(text: "성별")
    public lazy var dogGenderSelectButton = commonButton().then {
        $0.setTitle("성별", for: .normal)
    }
    
    private lazy var triangleImage = UIImageView().then {
        $0.image = .reverseTriangle
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var birthdateLabel = commonLabel(text: "생일")
    public lazy var birthdateSelectButton = commonButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.textAlignment = .left
    }
    
    public lazy var confirmButton = ConfirmButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
    }
    
    public func configure(pet: Pet) {
        self.petInfo = pet
        self.petNameTextField.text = pet.name
        self.dogTypeTextField.text = pet.type
        switch pet.size {
        case "BIG":
            self.selectedDogSize = .BIG
            bigPetSizeButton.setSelectedImage()
        case "SMALL":
            self.selectedDogSize = .SMALL
            smallPetSizeButton.setSelectedImage()
        case "MIDDLE":
            self.selectedDogSize = .MEDIUM
            middlePetSizeButton.setSelectedImage()
        default :
            break
        }
        
        // 성별 설정 수정 - selectDogGender 메서드 사용
        switch pet.gender {
        case "MALE":
            self.selectDogGender(.MALE)
        case "FEMALE":
            self.selectDogGender(.FEMALE)
        default:
            self.selectDogGender(.NEUTER)
        }
        
        self.birthdateSelectButton.setTitle(pet.birth, for: .normal)
        self.navigationBar.configureTitle(title: "반려견 정보를 수장해주세요.")
        self.confirmButton.configure(labelText: "수정하기")
    }
    
    public func setConstraints() {
        setCustomNavigationBarConstraints()
        setScrollViewConstraints()
        setPetImageConstraints()
        setTypeNameConstraints()
        setSelectPuppySizeConstraints()
        setDogTypeConstraints()
        setDogGenderConstraints()
        setBirthdateConstraints()
    }
    
    private func setCustomNavigationBarConstraints() {
        self.addSubview(navigationBar)
        navigationBar.configureTitle(title: "반려견 정보를 추가해주세요")
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setScrollViewConstraints() {
        self.addSubview(scrollView)
        self.addSubview(confirmButton)
        scrollView.addSubview(contentView)
        
        // 등록 버튼 설정
        confirmButton.configure(labelText: "등록하기")
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-53)
        }
        
        // 스크롤뷰 설정 (bottom 제약조건 중복 제거)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            // bottom 제약조건을 하나만 설정
            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
        }
        
        // contentView 설정
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
    
    private func setPetImageConstraints() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(cameraButton)
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.center.equalTo(profileImageView.snp.center).offset(30)
            make.width.height.equalTo(40)
        }
        
        cameraButton.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
    
    private func setTypeNameConstraints() {
        contentView.addSubview(petNameLabel)
        contentView.addSubview(petNameTextField)
        
        petNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(labelLeadingPadding)
            make.top.equalTo(profileImageView.snp.bottom).offset(39)
        }
        
        petNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(petNameLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    }
    
    private func setSelectPuppySizeConstraints() {
        let buttonWidth = (UIScreen.main.bounds.width - (leadingTrailingPadding * 2) - (stackSpacing * 2)) / 3
        
        contentView.addSubview(selectPetSizeLabel)
        contentView.addSubview(petSizeStackView)
        
        selectPetSizeLabel.snp.makeConstraints { make in
            make.top.equalTo(petNameTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(labelLeadingPadding)
        }
        
        petSizeStackView.snp.makeConstraints { make in
            make.top.equalTo(selectPetSizeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
        }
        
        let buttons = [smallPetSizeButton, middlePetSizeButton, bigPetSizeButton]
        
        for button in buttons {
            petSizeStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(buttonWidth)
            }
        }
    }
    
    private func setDogTypeConstraints() {
        contentView.addSubview(dogTypeLabel)
        contentView.addSubview(dogTypeTextField)
        
        dogTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(petSizeStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(labelLeadingPadding)
        }
        
        dogTypeTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(dogTypeLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    }
    
    private func setDogGenderConstraints() {
        contentView.addSubview(dogGenderLabel)
        contentView.addSubview(dogGenderSelectButton)
        contentView.addSubview(triangleImage)
        
        dogGenderLabel.snp.makeConstraints { make in
            make.top.equalTo(dogTypeTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(labelLeadingPadding)
        }
        
        dogGenderSelectButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(dogGenderLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        dogGenderSelectButton.titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        triangleImage.snp.makeConstraints { make in
            make.centerY.equalTo(dogGenderSelectButton)
            make.trailing.equalTo(dogGenderSelectButton).offset(-22)
            make.width.equalTo(10)
        }
    }
    
    private func setBirthdateConstraints() {
        contentView.addSubview(birthdateLabel)
        contentView.addSubview(birthdateSelectButton)
        
        birthdateLabel.snp.makeConstraints { make in
            make.top.equalTo(dogGenderSelectButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(labelLeadingPadding)
        }
        
        birthdateSelectButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(birthdateLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
        
//        birthdateSelectButton.titleLabel?.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(30)
//            make.centerY.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-20)
//        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 15)
        }
    }
        
    private func commonButton() -> UIButton {
        return UIButton().then {
            $0.backgroundColor = .white
            $0.setTitleColor(.gray03, for: .normal)
            
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.brown02.cgColor
        }
    }
    
    public func selectDogGender(_ gender: DogGenderEnum) {
        dogGenderSelectButton.setTitle(gender.inKorean(), for: .normal)
        dogGenderSelectButton.setTitleColor(.black, for: .normal)
        selectedDogGender = gender
    }
    
    enum DogGenderEnum: String, Codable {
        case MALE, FEMALE, NEUTER
        func inKorean() -> String {
            switch self {
            case .MALE:
                return "수컷"
            case .FEMALE:
                return "암컷"
            case .NEUTER:
                return "중성화"
            }
        }
    }
}

import SwiftUI
#Preview {
    EditOrRegistPetViewController()
}
