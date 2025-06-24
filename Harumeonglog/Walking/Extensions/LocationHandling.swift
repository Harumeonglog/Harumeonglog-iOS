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


protocol LocationHandling where Self: UIViewController {
    var locationManager: CLLocationManager { get }
    var mapView: MapView { get }

    func moveCameraToCurrentLocation()
}

extension LocationHandling {
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
}

