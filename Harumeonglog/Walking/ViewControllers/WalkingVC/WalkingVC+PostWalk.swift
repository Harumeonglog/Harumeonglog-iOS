//
//  WalkingVC+PostWalk.swift
//  Harumeonglog
//
//  Created by 김민지 on 7/17/25.
//

import UIKit
import CoreLocation
import NMapsMap


// MARK: 산책 기록 결과
extension WalkingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    func showRecordWalkingView(with mapImage: UIImage?) {
        let recordView = showDimmedView(RecordView.self)
        self.recordView = recordView
        
        recordView.profileCollectionView.delegate = self
        recordView.profileCollectionView.dataSource = self
        recordView.profileCollectionView.reloadData()

        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnRecordView))
        dismissTap.cancelsTouchesInView = false
        dismissTap.delegate = self
        recordView.addGestureRecognizer(dismissTap)
        
        recordView.totalDistance.text = walkingView.recordDistance.text
        recordView.totalTime.text = walkingView.recordTime.text
        getPlaceName(from: self.startLocationCoordinates) { address in
            recordView.startAdddress.text = address
            print("\(address)")
        }
        
        if let mapImage = mapImage {
            recordView.mapImageView.image = mapImage
        }
        recordView.recordCancelBtn.addTarget(self, action: #selector(cancelRecordBtnTapped), for: .touchUpInside)
        recordView.recordSaveBtn.addTarget(self, action: #selector(saveRecordBtnTapped), for: .touchUpInside)
    }
    
    @objc func cancelRecordBtnTapped() {
        removeView(RecordView.self)
        navigationController!.popToRootViewController(animated: true)
    }
    
    
    
    // 산책 기록 저장
    @objc func saveRecordBtnTapped() {
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
    
extension WalkingViewController {
    @objc fileprivate func dismissKeyboardOnRecordView() {
        self.view.endEditing(true)
    }
}

// MARK: 산책 공유
extension WalkingViewController {
    func showShareWalkingView() {
        let shareRecordView = showDimmedView(ShareRecordView.self)
        shareRecordView.shareCancelBtn.addTarget(self, action: #selector(cancelShareBtnTapped), for: .touchUpInside)
        shareRecordView.shareBtn.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
    }
    
    @objc func cancelShareBtnTapped() {
        removeView(ShareRecordView.self)
        navigationController!.popToRootViewController(animated: true)
    }
    
    @objc func shareBtnTapped() {
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
    func removeView<T: UIView>(_ viewType: T.Type) {
        if let window = UIApplication.shared.windows.first {
            window.subviews.forEach { subview in
                if subview is T || subview.backgroundColor == UIColor.black.withAlphaComponent(0.5) {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    func showDimmedView<T: UIView>(_ viewType: T.Type) -> T {
        if let window = UIApplication.shared.windows.first {
            let dimmedView = UIView(frame: window.bounds)
            dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            // 배경 터치 시 키보드 내리기
            let bgTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnRecordView))
            bgTap.cancelsTouchesInView = false
            dimmedView.addGestureRecognizer(bgTap)
            
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
