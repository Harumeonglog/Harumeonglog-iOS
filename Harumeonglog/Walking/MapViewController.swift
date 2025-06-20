//
//  MapViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController {
    
    private var recommendRoutes: [WalkRecommendItem] = []
    
    var chooseDogView = ChooseDogView()
    var choosePersonView = ChoosePersonView()
    let walkRecommendService = WalkRecommendService()
    
    private var isExpanded = false  // 추천 경로 모달창 expand 상태를 나타내는 변수
    private let minHeight: CGFloat = 150
    private let maxHeight: CGFloat = 750

    private var cursor: Int = 0
    private var hasNext: Bool = true
    private var isFetching: Bool = false 
    
    private var locationManager = CLLocationManager()
    private var userLocationMarker: NMFMarker?      // 네이버지도에서 마커 객체 선언

    private lazy var mapView: MapView = {
        let view = MapView()
        
        view.moveToUserLocationButton.addTarget(self, action: #selector(moveToUserLocationButtonTapped), for: .touchUpInside)
        view.walkingStartButton.addTarget(self, action: #selector(walkingStartButtonTapped), for: .touchUpInside)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.recommendRouteView.addGestureRecognizer(panGesture)  // 슬라이드 제스처
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.mapView
        
        mapView.recommendRouteTableView.delegate = self
        mapView.recommendRouteTableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest    // 거리 정확도 설정
        locationManager.requestWhenInUseAuthorization()              // 서비스 권한을 허용할 것인지 묻는 팝업
        
        configRouteFilterButton()
    }
    
    @objc func walkingStartButtonTapped() {
        chooseDogView = showDimmedView(ChooseDogView.self)
        
        chooseDogView.dogCollectionView.delegate = self
        chooseDogView.dogCollectionView.dataSource = self
        chooseDogView.dogCollectionView.allowsMultipleSelection = true

        chooseDogView.chooseSaveBtn.addTarget(self, action: #selector(saveDogBtnTapped), for: .touchUpInside)
    }
    
    
    @objc private func saveDogBtnTapped() {
        removeView(ChooseDogView.self)
        choosePersonView = showDimmedView(ChoosePersonView.self)
        
        choosePersonView.personCollectionView.delegate = self
        choosePersonView.personCollectionView.dataSource = self
        choosePersonView.personCollectionView.allowsMultipleSelection = true
        
        choosePersonView.chooseSaveBtn.addTarget(self, action: #selector(savePersonBtnTapped), for: .touchUpInside)
    }
    
    @objc private func savePersonBtnTapped() {
        removeView(ChoosePersonView.self)
        let walkingVC = WalkingViewController()
        walkingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(walkingVC, animated: true)
    }
    
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
          switch gesture.state {
          
          // 제스처가 끝났을때 확장/축소 결정
          case .ended:
              if !isExpanded {
                  fetchRouteData(reset: true, sort: "RECOMMEND")
              }
              
              let velocity = gesture.velocity(in: mapView.recommendRouteView).y  // 초당 픽셀 이동 속도
              if velocity < -500 { // 위로 빠르게 스와이프 -> 확장
                  isExpanded = true
              } else if velocity > 500 { // 아래로 빠르게 스와이프 -> 축소
                  isExpanded = false
              }
              
              let finalHeight = isExpanded ? maxHeight : minHeight
              mapView.recommendRouteView.snp.updateConstraints { make in
                  make.height.equalTo(finalHeight)
              }
              
              // 높이에 따라 버튼 숨기기
              mapView.petStoreButton.isHidden = isExpanded
              mapView.vetButton.isHidden = isExpanded
              mapView.recommendRouteLabel.isHidden = !isExpanded
              mapView.routeFilterButton.isHidden = !isExpanded
              mapView.recommendRouteTableView.isHidden = !isExpanded
              
              UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
              }
          default:
              break
          }
      }
    
    // 정렬을 위한 팝업버튼
    private func configRouteFilterButton() {
        let popUpButtonClosure = { (action: UIAction) in
            if action.title == "추천순" {
                self.mapView.routeFilterButton.setTitle("추천순", for: .normal)
                
            } else if action.title == "거리순" {
                self.mapView.routeFilterButton.setTitle("거리순", for: .normal)
                
            } else if action.title == "소요 시간순" {
                self.mapView.routeFilterButton.setTitle("소요 시간순", for: .normal)
            }
            
            self.mapView.recommendRouteTableView.reloadData()
        }
        
        mapView.routeFilterButton.menu = UIMenu(title: "정렬", children: [
            UIAction(title: "추천순", handler: popUpButtonClosure),
            UIAction(title: "거리순", handler: popUpButtonClosure),
            UIAction(title: "소요 시간순", handler: popUpButtonClosure),
        ])
        
        mapView.routeFilterButton.showsMenuAsPrimaryAction = true
    }
    
    
    private func fetchRouteData(reset: Bool = false, sort: String) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else {
             print("토큰 없음")
             return
         }
        
        if isFetching { return }
        isFetching = true
        
        if reset {
            cursor = 0
            hasNext = true
            recommendRoutes.removeAll()
            mapView.recommendRouteTableView.reloadData()
        }
        
        walkRecommendService.fetchWalkRecommends(sort: sort, cursor: cursor, size: 10, token: token){ [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let response):
                if response.isSuccess {
                    if let routeList = response.result {
                        self.recommendRoutes.append(contentsOf: routeList.items)
                        
                        print("추천 경로 조회 성공: \(recommendRoutes.count)")
                        self.cursor = routeList.cursor ?? 0
                        self.hasNext = routeList.hasNext
                        DispatchQueue.main.async {
                            self.mapView.recommendRouteTableView.reloadData()
                        }
                        
                    }
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("추천 경로 조회 실패: \(error.localizedDescription)")
            }
        }
    }
}


// MARK: 네이버지도
extension MapViewController: CLLocationManagerDelegate {
    
    // 현재 위치로 이동하는 함수
    @objc func moveToUserLocationButtonTapped() {
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 on 상태")
            
            let status = locationManager.authorizationStatus
            
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()     // 최초 요청
            case .denied, .restricted:
                showLocationPermissionAlert()                       // 설정으로 이동하도록 유도
            case .authorizedWhenInUse, .authorizedAlways:
                // 위치 업데이트가 아직 시작되지 않았다면 시작
                if locationManager.location == nil {
                    locationManager.startUpdatingLocation()  // 처음 위치를 받아오기 시작
                }
                // 위치 업데이트 없이 현재 위치로 이동하는 함수 호출
                moveCameraToCurrentLocation()

            @unknown default:
                break
            }
        } else {
            print("위치 서비스 off 상태")
            // 위치 서비스 자체가 꺼진 경우 (기기 설정에서 GPS OFF)
            showLocationPermissionAlert()
        }
    }
    
    // 위치가 이동할 때마다 위치 정보 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        // 가장 최근에 받아온 위치
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("위도: \(latitude), 경도: \(longitude)")
        }
    }

    // 위치 정보를 기반으로 카메라 이동 & 마커 이동
    func moveCameraToCurrentLocation() {
        if let location = locationManager.location {
            print("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
            
            let userLatLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            let cameraUpdate = NMFCameraUpdate(scrollTo: userLatLng)
            cameraUpdate.animation = .easeIn
            mapView.naverMapView.mapView.moveCamera(cameraUpdate)
            
            let marker = NMFMarker()
            marker.width = 30
            marker.height = 30
            marker.position = userLatLng
            marker.iconImage = NMFOverlayImage(image: UIImage(named: "currentLocation")!)
            marker.mapView = mapView.naverMapView.mapView
            
        } else {
            print("위치 정보가 없습니다.")
            // 위치 정보가 없으면 기본 위치로 이동
            let userLatLng = NMGLatLng(lat: 37.5665, lng: 126.9780)
            let cameraUpdate = NMFCameraUpdate(scrollTo: userLatLng)
            cameraUpdate.animation = .easeIn
            mapView.naverMapView.mapView.moveCamera(cameraUpdate)
        }
    }

    // 위도 경도 받아오기 에러
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error)
     }
    
    // 위치 접근 권한 허용안한 경우 설정에 들어가도록 유도
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "위치 권한 필요",
                                      message: "현재 위치를 사용하려면 설정에서\n 위치 접근을 허용해 주세요.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: 추천 경로에 대한 tableView
extension MapViewController: UITableViewDelegate, UITableViewDataSource, RecommendRouteTableViewCellDelegate {
    
    
    // 셀 등록
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recommendRoutes = recommendRoutes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendRouteTableViewCell", for: indexPath) as! RecommendRouteTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: recommendRoutes)
        cell.delegate = self
        

        return cell
    }
    
    func likeButtonTapped(in cell: RecommendRouteTableViewCell) {
        if let indexPath = mapView.recommendRouteTableView.indexPath(for: cell) {
            print("좋아요버튼 클릭됨")
        }
    }
    
    // 셀 갯수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recommendRoutes.count
    }
    
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 + 20
    }
    
    // 셀 선택 아예 못하게 막기
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: 산책 멤버 선택에 대한 collectionView
extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseProfileViewCell", for: indexPath) as? ChooseProfileViewCell
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
        // 선택된 셀 상태를 업데이트
        if let cell = collectionView.cellForItem(at: indexPath) as? ChooseProfileViewCell {
            cell.isSelected = true
            updateSaveBtn(isEnabled: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ChooseProfileViewCell {
            cell.isSelected = false
            
            let hasSelection = !(collectionView.indexPathsForSelectedItems?.isEmpty ?? true)
            updateSaveBtn(isEnabled: hasSelection)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    // 셀선택.해제시 다음 버튼 활성화 함수
    private func updateSaveBtn(isEnabled: Bool) {
        let color: UIColor = isEnabled ? .blue01 : .gray03
        chooseDogView.chooseSaveBtn.backgroundColor = color
        chooseDogView.chooseSaveBtn.isEnabled = isEnabled
        choosePersonView.chooseSaveBtn.backgroundColor = color
        choosePersonView.chooseSaveBtn.isEnabled = isEnabled
    }
}


// MARK: View 띄우기 및 삭제
extension MapViewController {
    // view를 띄운걸 삭제하기 위한 공통 함수
    private func removeView<T: UIView>(_ viewType: T.Type) {
        if let window = UIApplication.shared.windows.first {
            window.subviews.forEach { subview in
                if subview is T || subview.backgroundColor == UIColor.black.withAlphaComponent(0.5) {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    private func showDimmedView<T: UIView>(_ viewType: T.Type) -> T {
        if let window = UIApplication.shared.windows.first {
            // dimmedView 생성
            let dimmedView = UIView(frame: window.bounds)
            dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            // 배경 터치 시 popToRootViewController
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
            dimmedView.addGestureRecognizer(tapGesture)
            
            // 실제 띄우고 싶은 뷰 생성
            let view = T()
            window.addSubview(dimmedView)
            window.addSubview(view)
            view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            return view
        }
        return T()
    }
    
    @objc private func dimmedViewTapped() {
        // 모든 dimmed 및 선택 뷰 제거
        removeView(ChooseDogView.self)
        removeView(ChoosePersonView.self)
    }
}
