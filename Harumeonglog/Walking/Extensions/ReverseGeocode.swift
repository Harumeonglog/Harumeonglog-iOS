//
//  ReverseGeocode.swift
//  Harumeonglog
//
//  Created by 김민지 on 6/27/25.
//

import CoreLocation
import UIKit

extension UIViewController {
    
    func getPlaceName(from coordinates: [Double], completion: @escaping (String) -> Void) {
        guard coordinates.count == 2 else {
            completion("위치 정보 없음")
            return
        }

        let latitude = coordinates[0]
        let longitude = coordinates[1]
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("역지오코딩 실패: \(error.localizedDescription)")
                completion("주소 불러오기 실패")
                return
            }
            
            if let placemark = placemarks?.first {
                let name = placemark.name ?? ""
                let city = placemark.locality ?? ""
                let road = placemark.thoroughfare ?? ""

                let address = "\(city) \(road) \(name)"
                completion(address)
            } else {
                completion("주소 정보 없음")
            }
        }
    }


}
