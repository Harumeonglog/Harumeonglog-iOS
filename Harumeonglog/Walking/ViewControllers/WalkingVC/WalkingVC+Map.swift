//
//  WalkingVC+Map.swift
//  Harumeonglog
//
//  Created by 김민지 on 7/18/25.
//

import UIKit
import CoreLocation
import NMapsMap


// MARK: 네이버지도
extension WalkingViewController: CLLocationManagerDelegate, LocationHandling {
    
    var mapContainer: WalkingView { walkingView }
    
    // 현재 위치로 이동하는 함수
    @objc func moveToUserLocationButtonTapped() {
        handleUserLocationAuthorization()
    }
    
    // 위치가 이동할 때마다 위치 정보 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        let currentCoord = NMGLatLng(lat: lat, lng: lng)
        
        // 마커 업데이트
        if currentLocationMarker == nil {
            currentLocationMarker = NMFMarker(position: currentCoord)
            currentLocationMarker?.mapView = walkingView.naverMapView.mapView
        } else {
            currentLocationMarker?.position = currentCoord
        }
        
        guard walkState == .walking else { return }                 // 선은 걷는 중일 때만 그려짐
        
        // 경로 배열에 추가
        currentCoordinates.append(currentCoord)
        
        // 거리 계산
         if let lastLoc = lastLocation {
             let newDistance = location.distance(from: lastLoc) // 미터 단위
             totalDistance += newDistance

             let totalDistanceInKm = totalDistance / 1000.0
             // 거리 UI 업데이트
             walkingView.recordDistance.text = String(format: "%.2f", totalDistanceInKm)
         }
         lastLocation = location
        
        // 현재 pathOverlay가 있으면 path 갱신
        DispatchQueue.main.async {
            self.pathOverlay?.path = NMGLineString(points: self.currentCoordinates)
        }
        
        // 처음 시작 시 카메라 위치 이동
        if currentCoordinates.count == 1 {
            let cameraUpdate = NMFCameraUpdate(scrollTo: currentCoord)
            cameraUpdate.animation = .easeIn
            walkingView.naverMapView.mapView.moveCamera(cameraUpdate)
        }
    }
    

    func startNewPathOverlay(resetPath: Bool = true) {
        if resetPath {
            currentCoordinates = [] // 재개 시 false로 넘기면 초기화하지 않음
        }
        
        let newPath = NMFPath()
        
        newPath.path = NMGLineString(points: currentCoordinates)
        newPath.color = UIColor.blue01
        newPath.width = 5
        newPath.mapView = walkingView.naverMapView.mapView

        pathOverlays.append(newPath)
        pathOverlay = newPath               // 현재 pathOverlay 포인터 갱신
    }


    // 위도 경도 받아오기 에러
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error)
     }

}
