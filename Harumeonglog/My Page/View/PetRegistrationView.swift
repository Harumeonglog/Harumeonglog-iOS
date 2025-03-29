//
//  PuppyRegistration.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/17/25.
//

import UIKit
import SnapKit
import Then

class PetRegistrationView: UIView {
        
    public var selectedDogSize: DogSizeEnum?
    public var selectedDogGender: DogGenderEnum?
    private let labelLeadingPadding: CGFloat = 41
    private let leadingTrailingPadding: CGFloat = 28
    private let stackSpacing: CGFloat = 20
    
    public let navigationBar = CustomNavigationBar()
    
    private lazy var petNameLabel = commonLabel(text: "반려견 이름")
    public lazy var petNameTextField = UITextField.commonTextField()
    
    private lazy var selectPetSizeLabel = commonLabel(text: "반려견 크기")
    private lazy var petSizeStackView = UIStackView().then {
        $0.spacing = stackSpacing
    }
    
    public lazy var smallPetSizeButton = DogSizeButton()
    public lazy var middlePetSizeButton = DogSizeButton()
    public lazy var bigPetSizeButton = DogSizeButton()
    
    private lazy var dogTypeLabel = commonLabel(text: "견종")
    public lazy var dogTypeTextField = UITextField.commonTextField()
    
    private lazy var dogGenderLabel = commonLabel(text: "성별")
    public lazy var dogGenderSelectButton = commonButton()
    
    private lazy var triangleImage = UIImageView().then {
        $0.image = .reverseTriangle
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var birthdateLabel = commonLabel(text: "나이")
    public lazy var birthdateSelectButton = commonButton()
    
    public lazy var registButton = ConfirmButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
    }
    
    public func setConstraints() {
        setCustomNavigationBarConstraints()
        setTypeNameConstraints()
        setSelectPuppySizeConstraints()
        setDogTypeConstraints()
        setDogGenderConstraints()
        setBirthdateConstraints()
        setRegistButtonConstraints()
    }
    
    private func setCustomNavigationBarConstraints() {
        navigationBar.configureTitle(title: "반려견 정보를 추가해주세요")
        
        self.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setTypeNameConstraints() {
        self.addSubview(petNameLabel)
        self.addSubview(petNameTextField)
        
        petNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(labelLeadingPadding)
            make.top.equalTo(navigationBar.snp.bottom).offset(39)
        }
        
        petNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(petNameLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    }
    
    private func setSelectPuppySizeConstraints() {
        let buttonWidth = (UIScreen.main.bounds.width - (leadingTrailingPadding * 2) - (stackSpacing * 2)) / 3
        
        self.addSubview(selectPetSizeLabel)
        self.addSubview(petSizeStackView)
        
        selectPetSizeLabel.snp.makeConstraints { make in
            make.top.equalTo(petNameTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(labelLeadingPadding)
        }
        
        petSizeStackView.snp.makeConstraints { make in
            make.top.equalTo(selectPetSizeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
        }
        
        smallPetSizeButton.configure(size: .small)
        middlePetSizeButton.configure(size: .middle)
        bigPetSizeButton.configure(size: .big)
        
        let buttons = [smallPetSizeButton, middlePetSizeButton, bigPetSizeButton]
        
        for button in buttons {
            petSizeStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(buttonWidth)
            }
        }
    }
    
    private func setDogTypeConstraints() {
        self.addSubview(dogTypeLabel)
        self.addSubview(dogTypeTextField)
        
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
        self.addSubview(dogGenderLabel)
        self.addSubview(dogGenderSelectButton)
        self.addSubview(triangleImage)
        
        dogGenderLabel.snp.makeConstraints { make in
            make.top.equalTo(dogTypeTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(labelLeadingPadding)
        }
        
        dogGenderSelectButton.setTitle("성별", for: .normal)
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
        self.addSubview(birthdateLabel)
        self.addSubview(birthdateSelectButton)
        
        birthdateLabel.snp.makeConstraints { make in
            make.top.equalTo(dogGenderSelectButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(labelLeadingPadding)
        }
        
        birthdateSelectButton.setTitle("생일", for: .normal)
        birthdateSelectButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(birthdateLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        birthdateSelectButton.titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setRegistButtonConstraints() {
        self.addSubview(registButton)
        
        registButton.configure(labelText: "등록하기")
        registButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-53)
        }
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
    
    enum DogGenderEnum {
        case male, female, neutered
        
        func inKorean() -> String {
            switch self {
            case .male:
                return "수컷"
            case .female:
                return "암컷"
            case .neutered:
                return "중성화"
            }
        }
    }
}

import SwiftUI
#Preview {
    PetRegistrationViewController()
}
