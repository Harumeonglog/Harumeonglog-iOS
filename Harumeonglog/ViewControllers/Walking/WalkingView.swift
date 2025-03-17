//
//  WalkingView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/17/25.
//

import UIKit
import CoreLocation
import NMapsMap
import SnapKit
import Then

class WalkingView: UIView {
    
    public lazy var naverMapView = NMFNaverMapView()
    
    public lazy var petStoreButton: UIButton = findPlaceButton(image: "petShop", title: "펫 샵")
    
    public lazy var vetButton: UIButton = findPlaceButton(image: "vet", title: "병 원")
    
    public lazy var moveToUserLocationButton = UIButton().then { button in
        button.setImage(UIImage(named: "userLocation"), for: .normal)
    }
    
    public lazy var walkingStartButton = UIButton().then { button in
        button.setTitle("산책 시작", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .init(name: "Pretendard-Bold", size: 15)
        button.backgroundColor = UIColor(named: "blue01")
        button.layer.cornerRadius = 20
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func findPlaceButton(image: String, title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .init(name: "Pretendard-Regular", size: 13)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(named: "brown00")?.cgColor
        button.layer.borderWidth = 1
        
        let petStoreLogo = UIImage(named: image)
        button.setImage(petStoreLogo, for: .normal)
        button.imageView?.frame = CGRect(x: 0 , y: 0, width: 13, height: 13)
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        return button
    }
    
    private func addComponents() {
        self.addSubview(naverMapView)
        naverMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        naverMapView.addSubview(petStoreButton)
        naverMapView.addSubview(vetButton)
        
        petStoreButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        vetButton.snp.makeConstraints { make in
            make.top.equalTo(petStoreButton)
            make.leading.equalTo(petStoreButton.snp.trailing).offset(10)
            make.width.height.equalTo(petStoreButton)
        }
        
        naverMapView.addSubview(moveToUserLocationButton)
        naverMapView.addSubview(walkingStartButton)
        
        moveToUserLocationButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(177)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        
        walkingStartButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(177)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(90)
            make.height.equalTo(45)
        }
        
    }
}
