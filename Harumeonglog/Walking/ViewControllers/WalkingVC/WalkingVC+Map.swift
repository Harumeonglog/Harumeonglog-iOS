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
        guard let loc = locations.last else { return }

        let coord = NMGLatLng(lat: loc.coordinate.latitude, lng: loc.coordinate.longitude)

        // 마커는 항상 갱신
        DispatchQueue.main.async {
            if self.currentLocationMarker == nil {
                let m = NMFMarker(position: coord)
                m.mapView = self.walkingView.naverMapView.mapView
                self.currentLocationMarker = m
            } else {
                self.currentLocationMarker?.position = coord
            }
        }

        // 거리 누적 (표시는 걷는 중일 때만)
        if let last = lastLocation {
            totalDistance += loc.distance(from: last)
            if walkState == .walking {
                walkingView.recordDistance.text = String(format: "%.2f", totalDistance/1000.0)
            }
        }
        lastLocation = loc

        // 선은 '걷는 중'일 때만 그린다
        guard walkState == .walking else { return }

        // 여기서 바로 보이게 만드는 트릭
        if pathOverlay == nil {
            // 첫 점 들어온 순간, 점을 "두 번" 넣음 → 길이 2가 되어 즉시 선 표시
            currentCoordinates = [coord, coord]

            let overlay = NMFPath()
            overlay.width = 5
            overlay.color = UIColor.blue01     
            overlay.path = NMGLineString(points: currentCoordinates)

            DispatchQueue.main.async {
                overlay.mapView = self.walkingView.naverMapView.mapView
            }

            pathOverlay = overlay

            // 카메라도 최초 한 번 이동
            let u = NMFCameraUpdate(scrollTo: coord)
            u.animation = .easeIn
            walkingView.naverMapView.mapView.moveCamera(u)
        } else {
            // 이후 업데이트는 점 추가만
            currentCoordinates.append(coord)
            pathOverlay?.path = NMGLineString(points: currentCoordinates)
        }
    }

    
    func startNewPathOverlay(resetPath: Bool = true) {
        if resetPath || pathOverlay == nil {
            currentCoordinates.removeAll()
            pathOverlay = nil
        }
    }


    // 위도 경도 받아오기 에러
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error)
     }

}
