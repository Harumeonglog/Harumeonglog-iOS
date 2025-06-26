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
    
    var petList: [WalkPets] = []
    var memberList: [WalkMembers] = []
    
    var walkId: Int = 0
    
    var timer: Timer?
    var timeElapsed: TimeInterval = 0       // 경과 시간
    
    internal var locationManager = CLLocationManager()
    private var userLocationMarker: NMFMarker?      // 네이버지도에서 마커 객체 선언

    let walkRecommendService = WalkRecommendService()
    let walkMemberSercice = WalkMemberService()
    let walkService = WalkService()
    
    private lazy var walkingView: WalkingView = {
        let view = WalkingView()
        
        view.moveToUserLocationButton.addTarget(self, action: #selector(moveToUserLocationButtonTapped), for: .touchUpInside)
        view.endBtn.addTarget(self, action: #selector(endBtnTapped), for: .touchUpInside)
        view.playBtn.addTarget(self, action: #selector(stopBtnTapped), for: .touchUpInside)
        view.cameraBtn.addTarget(self, action: #selector(cameraBtnTapped), for: .touchUpInside)
        
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = walkingView
        locationManager.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    @objc private func endBtnTapped() {
        showAlertView()
    }
    
    
    // MARK: 산책 일시 정지
    @objc private func stopBtnTapped() {
        if timer == nil {
            // 산책 재게
            sendResumeWalkToServer()
            startTimer()
            walkingView.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)            
        } else {
            // 산책 정지
            sendStopWalkToServer()
            stopTimer()
            walkingView.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    private func sendResumeWalkToServer() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        walkService.walkResume(walkId: self.walkId, latitude: <#T##Double#>, longitude: <#T##Double#>, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {

                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 재게 전송 실패: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    private func sendStopWalkToServer() {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        walkService.walkPause(walkId: self.walkId, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {

                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 일시 정지 전송 실패: \(error.localizedDescription)")
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
        
        let endTime: Int = walkingView.recordTime.text.flatMap { Int($0) } ?? 0
        let endDistance: Int = Int(walkingView.recordDistance.text.flatMap { Double($0) } ?? 0.0)
        
        
        walkService.walkEnd(walkId: self.walkId, time: endTime, distance: endDistance, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    removeView(AlertView.self)
                    showRecordWalkingView()
                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 종료 실패: \(error.localizedDescription)")
                return
            }
        }
        
    }
    
    @objc private func cancelBtnTapped() {
        removeView(AlertView.self)
        startTimer()
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

           // 여기서 서버로 이미지 전송
           // uploadImageToServer(image)
       }
}

// MARK: 산책 기록 결과
extension WalkingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func showRecordWalkingView() {
        let recordView = showDimmedView(RecordView.self)
        
        recordView.profileCollectionView.delegate = self
        recordView.profileCollectionView.dataSource = self
        
        recordView.recordCancelBtn.addTarget(self, action: #selector(cancelRecordBtnTapped), for: .touchUpInside)
        recordView.recordSaveBtn.addTarget(self, action: #selector(saveRecordBtnTapped), for: .touchUpInside)
    }
    
    @objc private func cancelRecordBtnTapped() {
        removeView(RecordView.self)
        navigationController!.popToRootViewController(animated: true)
    }
    
    @objc private func saveRecordBtnTapped() {
        removeView(RecordView.self)
        showShareWalkingView()
    }
    
    // 셀 등록
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowProfileCollectionViewCell", for: indexPath) as? ShowProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
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
        print("didUpdateLocations")
        // 가장 최근에 받아온 위치
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("위도: \(latitude), 경도: \(longitude)")
        }
    }

    // 위도 경도 받아오기 에러
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error)
     }

}
