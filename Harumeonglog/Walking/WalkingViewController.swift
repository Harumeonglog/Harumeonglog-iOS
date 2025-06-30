//
//  WalkingViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/22/25.
//

import UIKit
import CoreLocation
import NMapsMap


class WalkingViewController: UIViewController {
    
    var selectedPets: [WalkPets] = []
    var selectedMembers: [WalkMembers] = []
    var selectedAllItems: [SelectedAllItems] = []
    
    var walkId: Int = 0
    
    var timer: Timer?
    var timeElapsed: TimeInterval = 0       // 경과 시간
    
    private var walkState: WalkState = .notStarted
    
    internal var locationManager = CLLocationManager()
    private var userLocationMarker: NMFMarker?          // 현재 위치를 가르키는 마커
    private var locationCoordinates: [NMGLatLng] = []   // 사용자의 이동 경로 저장하는 배열
    private var pathOverlay : NMFPath?                  // 실시간으로 갱신되는 선
    var startLocationCoordinates : [Double] = []
    
    private var selectedImage: UIImage?

    let walkRecommendService = WalkRecommendService()
    let walkMemberSercice = WalkMemberService()
    let walkService = WalkService()
    var recordView = RecordView()

    
    private lazy var walkingView: WalkingView = {
        let view = WalkingView()
        
        view.moveToUserLocationButton.addTarget(self, action: #selector(moveToUserLocationButtonTapped), for: .touchUpInside)
        view.endBtn.addTarget(self, action: #selector(endBtnTapped), for: .touchUpInside)
        view.playBtn.addTarget(self, action: #selector(playBtnTapped), for: .touchUpInside)
        view.cameraBtn.addTarget(self, action: #selector(cameraBtnTapped), for: .touchUpInside)
        
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = walkingView
        locationManager.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    // MARK: 산책 재개 및 일시 정지
    @objc private func playBtnTapped() {
        let currentLocation = locationManager.location
         guard let latitude = currentLocation?.coordinate.latitude,
               let longitude = currentLocation?.coordinate.longitude else {
             print("❗️현재 위치를 가져오지 못했습니다.")
             return
         }
        
        switch walkState {
        case .notStarted:
            // 산책 시작
            walkState = .walking
            self.startLocationCoordinates = [latitude, longitude]
            sendStartWalkToServer(latitude: latitude, longitude: longitude)
            startTimer()
            walkingView.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .walking:
            // 산책 일시정지
            walkState = .paused
            sendStopWalkToServer()
            stopTimer()
            walkingView.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        case .paused:
            // 산책 재개
            walkState = .walking
            sendResumeWalkToServer(latitude: latitude, longitude: longitude)
            startTimer()
            walkingView.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
        }
    }
    
    private func sendStartWalkToServer(latitude: Double, longitude: Double) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        let selectedPetIds = selectedPets.map { $0.petId }
        let selectedMemberIds = selectedMembers.map { $0.memberId }
        
        walkService.walkStart(petId: selectedPetIds, memberId: selectedMemberIds, startLatitude: latitude, startLongitude: longitude, token: token) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("산책 시작 성공")
                    self?.walkId = response.result!.walkId
                    print("\(self!.walkId)")
                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 시작 실패: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    private func sendResumeWalkToServer(latitude: Double, longitude: Double) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        print("\(self.walkId)")
        walkService.walkResume(walkId: self.walkId, latitude: latitude, longitude: longitude, token: token) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("산책 재개 성공")
                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 재개 실패: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    private func sendStopWalkToServer() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        walkService.walkPause(walkId: self.walkId, token: token) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("산책 일시정지 성공")
                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 일시 정지 실패: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    @objc private func cameraBtnTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true)
    }

    
    
    // MARK: 산책 종료 확인 알람
    @objc private func endBtnTapped() {
        locationManager.stopUpdatingLocation()          // 위치 추적 중지
        showAlertView()
    }
    
    private func showAlertView() {
        stopTimer()
        
        let alertView = AlertView(title: "산책을 끝내시겠습니까 ?", confirmText: "종료")
        
        // 뒷배경 어둡게 처리
        if let window = UIApplication.shared.windows.first {
            let dimmedView = UIView(frame: window.bounds)
            dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            window.addSubview(dimmedView)
            window.addSubview(alertView)
            
            alertView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        alertView.confirmBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
        alertView.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
    }
    
    
    // 산책 종료
    @objc private func confirmBtnTapped() {
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        let timeText = walkingView.recordTime.text ?? "00:00"
        let components = timeText.split(separator: ":").compactMap { Int($0) }
        let totalSeconds = (components.first ?? 0) * 60 + (components.last ?? 0)
        let endTime = totalSeconds / 60   // 정수 분 (소숫점 절삭)

        let distanceText = walkingView.recordDistance.text ?? "0"
        let endDistance = Int(Double(distanceText) ?? 0.0)
        
        
        walkService.walkEnd(walkId: self.walkId, time: endTime, distance: endDistance, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("산책 종료 성공")
                    removeView(AlertView.self)
                    showRecordWalkingView()
                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 종료 실패: \(error.localizedDescription)")

            }
        }
        
    }
    
    @objc private func cancelBtnTapped() {
        removeView(AlertView.self)
        startTimer()
        locationManager.startUpdatingLocation()     // 위치 추적 재게
        
    }
}






// MARK: 타이머 관련 메소드
extension WalkingViewController {
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        timeElapsed += 1
        updateTimeLabel()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        updateTimeLabel()
    }
    
    private func updateTimeLabel() {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        
        walkingView.recordTime.text = String(format: "%02d:%02d", minutes, seconds)
    }
}




// MARK: 사진 촬영 후 이미지 받아오기
extension WalkingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("이미지를 가져오지 못했습니다.")
            return
        }
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        // 여기서 서버로 이미지 전송
    }
    
 
}





// MARK: 산책 기록 결과
extension WalkingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func showRecordWalkingView() {
        let recordView = showDimmedView(RecordView.self)
        self.recordView = recordView
        
        recordView.profileCollectionView.delegate = self
        recordView.profileCollectionView.dataSource = self
        recordView.profileCollectionView.reloadData()
        
        recordView.totalDistance.text = walkingView.recordDistance.text
        recordView.totalTime.text = walkingView.recordTime.text
        getPlaceName(from: self.startLocationCoordinates) { address in
            recordView.startAdddress.text = address
            print("\(address)")
        }

        recordView.recordCancelBtn.addTarget(self, action: #selector(cancelRecordBtnTapped), for: .touchUpInside)
        recordView.recordSaveBtn.addTarget(self, action: #selector(saveRecordBtnTapped), for: .touchUpInside)
    }
    
    @objc private func cancelRecordBtnTapped() {
        removeView(RecordView.self)
        navigationController!.popToRootViewController(animated: true)
    }
    
    
    
    // 산책 기록 저장
    @objc private func saveRecordBtnTapped() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
    
        let title = recordView.walkingTextField.text ?? ""

        walkService.walkSave(walkId: self.walkId, title: title, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("산책 기록 저장 성공")
                    removeView(RecordView.self)
                    showShareWalkingView()
                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 기록 저장 실패: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    
    
    // 셀 등록
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = selectedAllItems[indexPath.row]

        switch item {
        case .pet(let pet):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowPetProfileCell", for: indexPath) as! ShowPetProfileCell
            cell.configurePet(with: pet)
            return cell

        case .member(let member):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowMemberProfileCell", for: indexPath) as! ShowMemberProfileCell
            cell.configureMember(with: member)
            return cell
        }

    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAllItems.count
    }
    
}
    
// MARK: 산책 공유
extension WalkingViewController {
    
    private func showShareWalkingView() {
        let shareRecordView = showDimmedView(ShareRecordView.self)
        
        shareRecordView.shareCancelBtn.addTarget(self, action: #selector(cancelShareBtnTapped), for: .touchUpInside)
        shareRecordView.shareBtn.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
    }
    
    @objc private func cancelShareBtnTapped() {
        removeView(ShareRecordView.self)
        navigationController!.popToRootViewController(animated: true)
    }
    
    
    @objc private func shareBtnTapped() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        walkService.walkShare(walkId: self.walkId, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    removeView(ShareRecordView.self)
                    navigationController!.popToRootViewController(animated: true)
                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 공유 실패: \(error.localizedDescription)")
                return
            }
        }
        
    }
}





// MARK: View 띄우기 및 삭제
extension WalkingViewController {
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
            let dimmedView = UIView(frame: window.bounds)
            dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            let view = T()
            
            self.walkingView.recordView.isHidden = true
            window.addSubview(dimmedView)
            window.addSubview(view)

            view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            return view
        }
        return T()
    }
}


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
        if userLocationMarker == nil {
            userLocationMarker = NMFMarker(position: currentCoord)
            userLocationMarker?.mapView = walkingView.naverMapView.mapView
        } else {
            userLocationMarker?.position = currentCoord
        }

        // 처음 시작 시 카메라 위치 이동
        if locationCoordinates.isEmpty {
            let cameraUpdate = NMFCameraUpdate(scrollTo: currentCoord)
            cameraUpdate.animation = .easeIn
            walkingView.naverMapView.mapView.moveCamera(cameraUpdate)
        }

        // 경로 배열에 추가
        locationCoordinates.append(currentCoord)

        // 선 업데이트
        if pathOverlay == nil {
            pathOverlay = NMFPath()
            pathOverlay?.mapView = walkingView.naverMapView.mapView
            
            // pathOverlay ui 설정
            pathOverlay?.color = UIColor.blue01
            pathOverlay?.width = 5
        }

        pathOverlay?.path = NMGLineString(points: locationCoordinates)
    }


    // 위도 경도 받아오기 에러
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error)
     }

}
