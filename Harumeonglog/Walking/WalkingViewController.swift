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
    var timeElapsed: TimeInterval = 0       // 경과 시간
    
    private var walkState: WalkState = .notStarted
    
    internal var locationManager = CLLocationManager()
    internal var currentLocationMarker: NMFMarker?
    var pathOverlay: NMFPath?                                   // 현재 그리고 있는 선 하나
    private var pathOverlays : [NMFPath] = []                  //  전체 산책 선 모음 배열
    private var currentCoordinates: [NMGLatLng] = []          //   현재 path에 해당하는 좌표 배열
    var startLocationCoordinates : [Double] = []
    private var totalDistance: CLLocationDistance = 0.0       // 거리 누적용
    private var lastLocation: CLLocation?
    
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
            locationManager.stopUpdatingLocation()
        case .paused:
            // 산책 재개
            walkState = .walking
            sendResumeWalkToServer(latitude: latitude, longitude: longitude)
            startTimer()
            walkingView.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            // 재개시 이전 경로 이어서 그리기 위해 초기화 안함 
            startNewPathOverlay(resetPath: false)
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
        
        let timeText = walkingView.recordTime.text ?? "00:00"
        let components = timeText.split(separator: ":").compactMap { Int($0) }
        let totalSeconds = (components.first ?? 0) * 60 + (components.last ?? 0)
        let endTime = totalSeconds / 60   // 정수 분 (소숫점 절삭)

        let distanceText = walkingView.recordDistance.text ?? "0"
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

             // 거리 UI 업데이트
             walkingView.recordDistance.text = String(format: "%.0f", totalDistance) // 정수로 표시
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
    

    private func startNewPathOverlay(resetPath: Bool = true) {
        if resetPath {
            currentCoordinates = [] // 재개 시 false로 넘기면 초기화하지 않음
        }
        let newPath = NMFPath()
        newPath.mapView = walkingView.naverMapView.mapView
        newPath.color = UIColor.blue01
        newPath.width = 5
        newPath.path = NMGLineString(points: currentCoordinates)
        pathOverlays.append(newPath)
        pathOverlay = newPath               // 현재 pathOverlay 포인터 갱신
    }


    // 위도 경도 받아오기 에러
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error)
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



// MARK: 사진 촬영 후 이미지 전송하기
extension WalkingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func cameraBtnTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("이미지를 가져오지 못했습니다.")
            return
        }
        walkImages.append(image)

        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        // 여기서 서버로 이미지 전송
        let index = walkImages.count - 1
        let imageInfos = [
            PresignedUrlImage(filename: "산책id:\(walkId)_\(index)", contentType: "image/jpeg")
        ]
        requestPresignedURLS(images: imageInfos, token: token)
    }
    
    
    private func requestPresignedURLS(images: [PresignedUrlImage], token: String) {
        // petId 하나당 하나의 PURLsRequestEntity 생성
        let entities = selectedPetIds.map { petId in
            return PURLsRequestEntity(entityId: petId, images: images)
        }
        PresignedUrlService.getPresignedUrls(domain: .pet, entities: entities, token: token) { [weak self] result in
            switch result {
            case .success(let response):
                print("presignedURL 발급 성공")
                self?.uploadImagesToPresignedURL(response.result!)
            case .failure(let error):
                print("presignedURL 발급 실패: \(error)")
            }
        }
    }
    
    private func uploadImagesToPresignedURL(_ result: PUrlsResult) {
        guard let presignedEntity = result.entities.first else { return }
        let presignedData = presignedEntity.images
        
        for (index, image) in walkImages.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8),
                  let url = URL(string: presignedData[index].presignedUrl) else {
                continue
            }
            uploadImageToS3(imageData: imageData, presignedUrl: url) { [weak self] result in
                switch result {
                case .success:
                    self?.imageKeys.append(presignedData[index].imageKey)
                case .failure(let error):
                    print("이미지 업로드 실패: \(error)")
                }
            }
        }
    }
}
