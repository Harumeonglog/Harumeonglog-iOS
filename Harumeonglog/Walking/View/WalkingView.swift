//
//  WalkingView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/22/25.
//


import UIKit
import SnapKit
import Then
import NMapsMap

class WalkingView: UIView {
    
    public lazy var naverMapView = NMFNaverMapView()
    
    public lazy var moveToUserLocationButton = UIButton().then { button in
        button.setImage(UIImage(named: "userLocation"), for: .normal)
    }
    
    public lazy var recordView = UIView().then { view in
        view.backgroundColor = UIColor.background
        view.layer.cornerRadius = 45
        view.layer.maskedCorners =  [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private lazy var recordDistanceTimeView = UIView()
    
    public lazy var recordDistance = setDistanceTime(text: "0.00")
    public lazy var recordTime = setDistanceTime(text: "00:00")
    
    private func setDistanceTime(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.gray00
        label.textAlignment = .center
        label.font = .init(name: "Pretendard-Bold", size: 30)
        
        return label
    }
        
    private lazy var recordDistanceLabel = setDistanceTImeLabel(text: "거리(km)")
    private lazy var recordTimeLabel = setDistanceTImeLabel(text: "산책시간")
    
    private func setDistanceTImeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.gray02
        label.textAlignment = .center
        label.font = .init(name: "Pretendard-Regular", size: 15)
        
        return label
    }
    
    
    private lazy var btnStackView = UIStackView().then { stackView in
        stackView.addArrangedSubview(endBtn)
        stackView.addArrangedSubview(playBtn)
        stackView.addArrangedSubview(cameraBtn)
        stackView.axis = .horizontal
        stackView.spacing = 17
        
        playBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    public lazy var endBtn = UIButton().then { button in
        button.setImage(UIImage(named: "endBtn"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    }
    
    public lazy var playBtn = UIButton().then { button in
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular), forImageIn: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.tintColor = .white
        button.backgroundColor = .brown00
        button.layer.cornerRadius = 40
        button.isUserInteractionEnabled = true
    }
    
    public lazy var cameraBtn = UIButton().then { button in
        button.setImage(UIImage(named: "cameraBtn"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    }
    
    private lazy var bottomLineView = UIView().then  { view in
        view.backgroundColor = UIColor.gray04
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(naverMapView)
        naverMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        naverMapView.addSubview(recordView)
        recordView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            
            // 비율 제약은 '중간' 우선순위로
            make.height.equalTo(naverMapView.snp.height)
                .multipliedBy(0.27)
                .priority(.medium)

            // 최소 높이는 'required'로 (콘텐츠 확보가 최우선)
            make.height.greaterThanOrEqualTo(220)
                .priority(.required)
        }
        
        
        recordView.addSubview(recordDistanceTimeView)
        
        recordDistanceTimeView.addSubview(recordDistance)
        recordDistanceTimeView.addSubview(recordTime)
        recordDistanceTimeView.addSubview(recordDistanceLabel)
        recordDistanceTimeView.addSubview(recordTimeLabel)
        
        recordDistanceTimeView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.leading.trailing.equalToSuperview().inset(80)
        }
        
        recordDistance.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(recordDistanceLabel)
        }
        
        recordTime.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(recordTimeLabel)
        }
        
        recordDistanceLabel.snp.makeConstraints { make in
            make.top.equalTo(recordDistance.snp.bottom).offset(7)
            make.leading.equalToSuperview().inset(10)
        }
        
        recordTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(recordTime.snp.bottom).offset(7)
            make.trailing.equalToSuperview().inset(25)
        }
        
        recordView.addSubview(btnStackView)
        
        btnStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(recordDistanceTimeView.snp.bottom).offset(70)
        }
        
        naverMapView.addSubview(moveToUserLocationButton)
        moveToUserLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(recordView.snp.top).offset(-11)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
    }

}
