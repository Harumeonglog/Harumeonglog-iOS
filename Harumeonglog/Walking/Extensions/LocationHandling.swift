//
//  LocationHandling.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/24/25.
//

import Foundation
import UIKit
import CoreLocation
import NMapsMap

protocol LocationHandling: CLLocationManagerDelegate where Self: UIViewController {
    associatedtype MapContainerType
    var locationManager: CLLocationManager { get }
    var mapContainer: MapContainerType { get }
    
    // 현재 위치 마커 저장용 변수
    var currentLocationMarker: NMFMarker? { get set }

    func handleUserLocationAuthorization()
    func showLocationPermissionAlert()
    func moveCameraToCurrentLocation()
}

extension LocationHandling {
    
    func handleUserLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 on 상태")

            let status = locationManager.authorizationStatus

            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()

            case .denied, .restricted:
                showLocationPermissionAlert()

            case .authorizedWhenInUse, .authorizedAlways:
                if locationManager.location == nil {
                    locationManager.startUpdatingLocation()
                }
                moveCameraToCurrentLocation()

            @unknown default:
                break
            }
        } else {
            print("위치 서비스 off 상태")
            showLocationPermissionAlert()
        }
    }
    
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "위치 권한 필요",
                                      message: "사용자의 산책 경로를 파악하기 위해\n위치 권한이 필요합니다.",
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

// 위치 정보를 기반으로 카메라 이동 & 마커 이동
extension LocationHandling where MapContainerType: UIView {
    func moveCameraToCurrentLocation() {
        let naverMapView: NMFNaverMapView?
        
        // MapContainerType 아래에 있는 네이버 맵 뷰를 안전하게 추출
        if let walking = mapContainer as? WalkingView {
            naverMapView = walking.naverMapView
        } else if let map = mapContainer as? MapView {
            naverMapView = map.naverMapView
        } else {
            naverMapView = nil
        }

        guard let mapView = naverMapView else {
            print("mapView를 찾을 수 없음")
            return
        }

        if let loc = locationManager.location {
            let latLng = NMGLatLng(lat: loc.coordinate.latitude, lng: loc.coordinate.longitude)
            let upd = NMFCameraUpdate(scrollTo: latLng)
            upd.animation = .easeIn
            mapView.mapView.moveCamera(upd)
            
            // 기존 마커 제거
            currentLocationMarker?.mapView = nil
            
            // 새 마커 생성 후 저장
            let marker = NMFMarker(position: latLng)
            marker.mapView = mapView.mapView
            marker.iconImage = NMFOverlayImage(image: makeLocationMarkerImage())
            marker.width = 40
            marker.height = 40

            currentLocationMarker = marker
        }
    }
}


