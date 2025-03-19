//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit
import NMapsMap
import CoreLocation

class WalkingViewController: UIViewController {
    
    private var isExpanded = false  // 추천 경로 모달창 expand 상태를 나타내는 변수
    private let minHeight: CGFloat = 150
    private let maxHeight: CGFloat = 750
    
    private var locationManager = CLLocationManager()
    private var userLocationMarker: NMFMarker?      // 네이버지도에서 마커 객체 선언

    private lazy var walkingView: WalkingView = {
        let view = WalkingView()
        
        view.moveToUserLocationButton.addTarget(self, action: #selector(moveToUserLocationButtonTapped), for: .touchUpInside)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.recommendRouteView.addGestureRecognizer(panGesture)  // 슬라이드 제스처
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.walkingView
        
        walkingView.recommendRouteTableView.delegate = self
        walkingView.recommendRouteTableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest    // 거리 정확도 설정
        locationManager.requestWhenInUseAuthorization()              // 서비스 권한을 허용할 것인지 묻는 팝업    }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
          let translation = gesture.translation(in: walkingView.recommendRouteView)
          
          switch gesture.state {
          
          // 제스처가 끝났을때 확장/축소 결정
          case .ended:
              let velocity = gesture.velocity(in: walkingView.recommendRouteView).y  // 초당 픽셀 이동 속도
              if velocity < -500 { // 위로 빠르게 스와이프 -> 확장
                  isExpanded = true
              } else if velocity > 500 { // 아래로 빠르게 스와이프 -> 축소
                  isExpanded = false
              }
              
              let finalHeight = isExpanded ? maxHeight : minHeight
              walkingView.recommendRouteView.snp.updateConstraints { make in
                  make.height.equalTo(finalHeight)
              }
              
              // 높이에 따라 버튼 숨기기
              walkingView.petStoreButton.isHidden = isExpanded
              walkingView.vetButton.isHidden = isExpanded
              walkingView.recommendRouteLabel.isHidden = !isExpanded
              walkingView.routeFilterButton.isHidden = !isExpanded
              walkingView.recommendRouteTableView.isHidden = !isExpanded
              
              UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
              }
          default:
              break
          }
      }
}

extension WalkingViewController: CLLocationManagerDelegate {
    
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
            walkingView.naverMapView.mapView.moveCamera(cameraUpdate)
            
            let marker = NMFMarker()
            marker.width = 35
            marker.height = 40
            marker.position = userLatLng
            marker.iconImage = NMFOverlayImage(image: UIImage(named: "currentLocation")!)
            marker.mapView = walkingView.naverMapView.mapView
            
        } else {
            print("위치 정보가 없습니다.")
            // 위치 정보가 없으면 기본 위치로 이동
            let userLatLng = NMGLatLng(lat: 37.5665, lng: 126.9780)
            let cameraUpdate = NMFCameraUpdate(scrollTo: userLatLng)
            cameraUpdate.animation = .easeIn
            walkingView.naverMapView.mapView.moveCamera(cameraUpdate)
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

// 추천 경로에 대한 tableView
extension WalkingViewController: UITableViewDelegate, UITableViewDataSource {
    // 셀 등록
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendRouteTableViewCell") as? RecommendRouteTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    // 셀 갯수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 + 10
    }
    
    // 셀 선택 아예 못하게 막기
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

