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
    var selectedPetIds: [Int] {
        return selectedPets.map { $0.petId }
    }
    var selectedMemberIds: [Int] {
        return selectedMembers.map { $0.memberId }
    }

    var walkId: Int = 0
    var walkImages: [UIImage] = []
    var imageKeys: [String] = []

    var timer: Timer?
    private var lastStartAt: Date?              // 마지막 시작(또는 재개) 시각
    private var accumulated: TimeInterval = 0   // 일시정지까지의 누적 시간(초)
    
    var walkState: WalkState = .notStarted
    
    internal var locationManager = CLLocationManager()
    internal var currentLocationMarker: NMFMarker?
    
    
    var pathOverlay: NMFPath?
    var currentCoordinates: [NMGLatLng] = []

    var startLocationCoordinates : [Double] = []
    var totalDistance: CLLocationDistance = 0.0       // 거리 누적용
    var lastLocation: CLLocation?
    
    var selectedImage: UIImage?


    let walkRecommendService = WalkRecommendService()
    let walkMemberSercice = WalkMemberService()
    let walkService = WalkService()
    var recordView = RecordView()

    
    lazy var walkingView: WalkingView = {
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 8
        locationManager.pausesLocationUpdatesAutomatically = false
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        }
        locationManager.requestWhenInUseAuthorization()
        
        moveToUserLocationButtonTapped()
        hideKeyboardWhenTappedAround()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
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
            totalDistance = 0.0
            lastLocation = nil
            walkState = .walking
            self.startLocationCoordinates = [latitude, longitude]
            sendStartWalkToServer(latitude: latitude, longitude: longitude)
            startTimer()
            walkingView.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            startNewPathOverlay()
            locationManager.startUpdatingLocation()
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
            startNewPathOverlay(resetPath: true)   // 새 선 시작 (기존 선은 polylineOverlays에 남음)
            locationManager.startUpdatingLocation() 
        }
    }
    
    private func sendStartWalkToServer(latitude: Double, longitude: Double) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        walkService.walkStart(petId: selectedPetIds, memberId: selectedMemberIds, startLatitude: latitude, startLongitude: longitude, token: token) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("산책 시작 성공")
                    self?.walkId = response.result!.walkId
                    print("\(self!.walkId)")
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
                }
            case .failure(let error):
                print("산책 일시 정지 실패: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    // MARK: 산책 종료 확인 알람
    @objc private func endBtnTapped() {
        locationManager.stopUpdatingLocation()          // 위치 추적 중지
        showAlertView()
        stopTimer()
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
        switch walkState {
        case .notStarted:
            // 산책 시작하지 않았으면 홈화면으로 이동
            removeView(AlertView.self)
            navigationController!.popToRootViewController(animated: true)
        case .walking:
            sendEndWalkDataToServer()
        case .paused:
            sendEndWalkDataToServer()
        }
    }
    
    private func sendEndWalkDataToServer() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        if walkState == .walking { stopTimer() }

        let timeText = walkingView.recordTime.text ?? "00:00"
        let components = timeText.split(separator: ":").compactMap { Int($0) }
        let totalSeconds = (components.first ?? 0) * 60 + (components.last ?? 0)
        let endTime = totalSeconds / 60   // 정수 분 (소숫점 절삭)

        let endDistance = Int(totalDistance)

        walkService.walkEnd(walkId: self.walkId, time: endTime, distance: endDistance, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    print("산책 종료 성공")
                    removeView(AlertView.self)
                    showRecordWalkingView()
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
        guard timer == nil else { return }
        lastStartAt = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimeLabel()
        }
        RunLoop.main.add(timer!, forMode: .common)        // 스크롤 중에도 갱신
    }
    
    private func stopTimer() {
        if let last = lastStartAt {
            accumulated += Date().timeIntervalSince(last)
        }
        lastStartAt = nil
        timer?.invalidate()
        timer = nil
        updateTimeLabel()
    }
    
    @objc private func updateTimeLabel() {
        let running = lastStartAt.map { Date().timeIntervalSince($0) } ?? 0
        let total = accumulated + running
        let minutes = Int(total) / 60
        let seconds = Int(total) % 60
        walkingView.recordTime.text = String(format: "%02d:%02d", minutes, seconds)
    }
}
