//
//  WalkingViewController.swift
//  Harumeonglog
//
//  Created by 김민지 on 3/22/25.
//

import UIKit


class WalkingViewController: UIViewController {
    
    var timer: Timer?
    var timeElapsed: TimeInterval = 0       // 경과 시간
    
    private lazy var walkingView: WalkingView = {
        let view = WalkingView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = walkingView
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        walkingView.endBtn.addTarget(self, action: #selector(endBtnTapped), for: .touchUpInside)
        walkingView.stopBtn.addTarget(self, action: #selector(stopBtnTapped), for: .touchUpInside)
        walkingView.cameraBtn.addTarget(self, action: #selector(cameraBtnTapped), for: .touchUpInside)
        
        startTimer()
    }
    
    @objc private func endBtnTapped() {
        showAlertView()
    }
    
    @objc private func stopBtnTapped() {
        if timer == nil {
            startTimer()
            walkingView.stopBtn.setImage(UIImage(named: "stopBtn"), for: .normal)
            
        } else {
            stopTimer()
            walkingView.stopBtn.setImage(UIImage(named: "startBtn"), for: .normal)
        }
    }
    
    @objc private func cameraBtnTapped() {
        
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
    
    @objc private func confirmBtnTapped() {
        removeView(AlertView.self)
        showRecordWalkingView()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell else {
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
        removeView(ShareRecordView.self)
        navigationController!.popToRootViewController(animated: true)
        
        // 서버로 데이터 전송 !!
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
