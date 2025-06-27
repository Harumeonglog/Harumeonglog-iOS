//
//  MapView.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/17/25.
//

import UIKit
import SnapKit
import Then
import NMapsMap


class MapView: UIView {
    
    public lazy var naverMapView = NMFNaverMapView()
    
    public lazy var petStoreButton: UIButton = setfindPlaceButton(image: "petShop", title: "펫 샵")
    
    public lazy var vetButton: UIButton = setfindPlaceButton(image: "vet", title: "병 원")
    
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
    
    public lazy var recommendRouteView = UIView().then { view in
        view.backgroundColor = UIColor.background
        view.layer.cornerRadius = 45
        view.layer.maskedCorners =  [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    public lazy var recommendRouteLabel = UILabel().then { label in
        label.text = "추천 경로"
        label.font = .init(name: "Pretendard-Bold", size: 20)
        label.textColor = UIColor.brown00
        label.textAlignment = .center
    }
    
    public lazy var routeFilterButton =  UIButton().then { button in
        button.setTitle("추천순", for: .normal)
        button.setTitleColor(UIColor.gray00, for: .normal)
        button.titleLabel?.font = .init(name: "Pretendard-Regular", size: 12)
        button.backgroundColor = .clear
        
        let filterArrow = UIImage(named: "sortArrow")
        button.setImage(filterArrow, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .right
        button.contentVerticalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
    
    public lazy var recommendRouteTableView = UITableView().then { tableView in
        tableView.register(RecommendRouteTableViewCell.self, forCellReuseIdentifier: "RecommendRouteTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.background
    }
    
    private lazy var modalSlideImageView = UIImageView().then { imageView in
        imageView.image = UIImage(named: "modalSlide")
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
    
    private func setfindPlaceButton(image: String, title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .init(name: "Pretendard-Regular", size: 14)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(named: "brown00")?.cgColor
        button.layer.borderWidth = 1
        
        let placeLogo = UIImage(named: image)
        button.setImage(placeLogo, for: .normal)
        button.imageView?.frame = CGRect(x: 0 , y: 0, width: 13, height: 13)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -9, bottom: 0, right: 0)
        
        return button
    }
    
    private func setRecommendRouteView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.background
        view.layer.cornerRadius = 45
        view.layer.maskedCorners =  [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
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
            make.bottom.equalToSuperview().inset(170)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        
        walkingStartButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(170)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(90)
            make.height.equalTo(45)
        }
        
        naverMapView.addSubview(recommendRouteView)
        
        recommendRouteView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(150)
        }
        
        recommendRouteView.addSubview(modalSlideImageView)
        recommendRouteView.addSubview(recommendRouteLabel)
        recommendRouteView.addSubview(routeFilterButton)
        recommendRouteView.addSubview(recommendRouteTableView)
        recommendRouteView.addSubview(bottomLineView)
        
        modalSlideImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(11)
        }
        
        recommendRouteLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(modalSlideImageView.snp.bottom).offset(30)
        }
        
        routeFilterButton.snp.makeConstraints { make in
            make.lastBaseline.equalTo(recommendRouteLabel)
            make.leading.equalToSuperview().inset(30)
        }
        
        recommendRouteTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(recommendRouteLabel.snp.bottom).offset(30)
            make.bottom.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
}
