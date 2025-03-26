//
//  RecordView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/22/25.
//

import UIKit
import SnapKit
import Then

class RecordView: UIView {
    
    private lazy var titleLabel = UILabel().then { label in
        label.text = "오늘의 산책"
        label.textColor = .gray00
        label.textAlignment = .center
        label.font = .init(name: "Pretendard-Bold", size: 20)
    }
    
    public lazy var recordCancelBtn = UIButton().then { button in
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray00
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
    
    private lazy var conatinerView = UIView().then { view in
    }
    
    private lazy var walkingTitleLabel = UILabel().then { label in
        label.text = "산책명"
        label.textColor = .gray01
        label.font = .init(name: "Pretendard-Regular", size: 13)
    }
    
    public lazy var walkingTextField = UITextField().then { textfield in
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray02,
            .font: UIFont(name: "Pretendard-Regular", size: 13)!,
        ]
        let attributedPlaceholder = NSAttributedString(string: "망원한강공원 한바퀴", attributes: attributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.textColor = .gray01
        textfield.layer.cornerRadius = 15
        textfield.layer.borderColor = UIColor.brown02.cgColor
        textfield.layer.borderWidth = 1
    }
    
    private lazy var mapImageRecordStackView = UIStackView().then { stackView in
        stackView.addArrangedSubview(mapImageView)
        stackView.addArrangedSubview(recordStackView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
    }
    
    public lazy var mapImageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.borderColor = UIColor.brown02.cgColor
        imageView.layer.borderWidth = 1
    }
    
    private lazy var recordStackView = UIStackView().then { mainStackView in
        let addressStackView = UIStackView(arrangedSubviews: [startAdddress, startAddressLabel])
        addressStackView.axis = .vertical
        addressStackView.spacing = 2
        addressStackView.alignment = .leading
        
        let timeStackView = UIStackView(arrangedSubviews: [totalTime, totalTimeLabel])
        timeStackView.axis = .vertical
        timeStackView.spacing = 1
        timeStackView.alignment = .leading
        
        let distanceStackView = UIStackView(arrangedSubviews: [totalDistance, totalDistanceLabel])
        distanceStackView.axis = .vertical
        distanceStackView.spacing = 1
        distanceStackView.alignment = .leading
        
        mainStackView.addArrangedSubview(addressStackView)
        mainStackView.addArrangedSubview(timeStackView)
        mainStackView.addArrangedSubview(distanceStackView)
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.spacing = 10
    }
    
    public lazy var startAdddress = UILabel().then { label in
        label.text = "망원역 3번출구"
        label.textColor = .gray00
        label.font = .init(name: "Pretendard-Bold", size: 20)
        label.numberOfLines = 2
    }
    
    private lazy var startAddressLabel = regualrFont(text: "시작점")
    
    public lazy var totalTime = boldFont(text: "00:00:00")
    private lazy var totalTimeLabel = regualrFont(text: "소요시간")
    
    public lazy var totalDistance = boldFont(text: "0.00")
    private lazy var totalDistanceLabel = regualrFont(text: "km")
    
    private func boldFont(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .gray00
        label.font = .init(name: "Pretendard-Bold", size: 24)
        
        return label
    }
    
    private func regualrFont(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .gray02
        label.font = .init(name: "Pretendard-Regular", size: 13)
        
        return label
    }
    
    public lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then { layout in
        layout.minimumInteritemSpacing = 3
        layout.itemSize = CGSize(width: 50, height: 70)
    }).then { collectionView in
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
    }
    
    public lazy var recordSaveBtn = UIButton().then { button in
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 17)
        button.backgroundColor = .blue01
        button.layer.cornerRadius = 25
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(550)
        }
        
        self.addSubview(titleLabel)
        self.addSubview(recordCancelBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        
        recordCancelBtn.snp.makeConstraints { make in
            make.lastBaseline.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(25)
        }
        
        self.addSubview(conatinerView)
        
        conatinerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        conatinerView.addSubview(walkingTitleLabel)
        conatinerView.addSubview(walkingTextField)
        
        walkingTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            
        }
        
        walkingTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(walkingTitleLabel.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        
        conatinerView.addSubview(mapImageRecordStackView)
        
        mapImageRecordStackView.snp.makeConstraints { make in
            make.top.equalTo(walkingTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.lessThanOrEqualTo(180)
        }
        
        recordStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        conatinerView.addSubview(profileCollectionView)
        
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mapImageRecordStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        
        self.addSubview(recordSaveBtn)
        
        recordSaveBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.width.lessThanOrEqualTo(130)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(110)
        }
        
    }
}
