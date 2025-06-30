//
//  MapViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController {
    
    private var recommendRoutes: [WalkRecommendItem] = []
    private var petList: [WalkPets] = []
    private var memberList: [WalkMembers] = []
    private var selectedPets : [WalkPets] = []
    private var selectedMembers : [WalkMembers] = []
    
    var chooseDogView = ChooseDogView()
    var choosePersonView = ChoosePersonView()
    let walkRecommendService = WalkRecommendService()
    let walkMemberSercice = WalkMemberService()
    let walkService = WalkService()
    
    let walkRecommendService = WalkRecommendService()
    let walkMemberSercice = WalkMemberService()
    let walkService = WalkService()
    
    private var isExpanded = false  // 추천 경로 모달창 expand 상태를 나타내는 변수
    private let minHeight: CGFloat = 150
    private let maxHeight: CGFloat = 750

    private var cursor: Int = 0
    private var hasNext: Bool = true
    private var isFetching: Bool = false 
    
    internal var locationManager = CLLocationManager()
    private var userLocationMarker: NMFMarker?      // 네이버지도에서 마커 객체 선언

    internal lazy var mapView: MapView = {
        let view = MapView()
        
        view.moveToUserLocationButton.addTarget(self, action: #selector(moveToUserLocationButtonTapped), for: .touchUpInside)
        view.walkingStartButton.addTarget(self, action: #selector(walkingStartButtonTapped), for: .touchUpInside)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.recommendRouteView.addGestureRecognizer(panGesture)  // 슬라이드 제스처
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.mapView
        
        mapView.recommendRouteTableView.delegate = self
        mapView.recommendRouteTableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest    // 거리 정확도 설정
        locationManager.requestWhenInUseAuthorization()              // 서비스 권한을 허용할 것인지 묻는 팝업
        
        configRouteFilterButton()
    }
    
    @objc func walkingStartButtonTapped() {
        chooseDogView = showDimmedView(ChooseDogView.self)
        
        chooseDogView.dogCollectionView.allowsMultipleSelection = true
        chooseDogView.dogCollectionView.delegate = self
        chooseDogView.dogCollectionView.dataSource = self

        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }

        walkMemberSercice.fetchWalkAvailablePet(token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    self.petList = response.result!.pets
                    
                    if !self.petList.isEmpty {
                        // 산책할 반려견이 있는 경우
                        self.chooseDogView.dogCollectionView.reloadData()
                        chooseDogView.chooseSaveBtn.addTarget(self, action: #selector(saveDogBtnTapped), for: .touchUpInside)
                    } else {
                        // 산책할 반려견이 없는 경우
                        chooseDogView.dogCollectionView.isHidden = true
                        chooseDogView.titleLabel.isHidden = true
                        chooseDogView.nonDogLabel.isHidden = false
                        chooseDogView.chooseSaveBtn.setTitle("확인", for: .normal)
                        chooseDogView.chooseSaveBtn.addTarget(self, action: #selector(dimmedViewTapped), for: .touchUpInside)
                    }

                } else {
                    print("서버 응답 에러: \(response.message)")
                    return
                }
            case .failure(let error):
                print("산책 가능한 펫 조회 실패: \(error.localizedDescription)")
                return
            }
        }
        
    }
    
    
    @objc private func saveDogBtnTapped() {
        removeView(ChooseDogView.self)
        choosePersonView = showDimmedView(ChoosePersonView.self)
        
        choosePersonView.personCollectionView.allowsMultipleSelection = true
        choosePersonView.personCollectionView.delegate = self
        choosePersonView.personCollectionView.dataSource = self
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        
        let selectedPets = chooseDogView.dogCollectionView.indexPathsForSelectedItems?
            .compactMap { $0.item < petList.count ? petList[$0.item] : nil } ?? []

        self.selectedPets = selectedPets
        let selectedPetIds = selectedPets.map(\.petId)  // 선택한 pet id값만 추출
        
        
        print("선택된 펫 id: \(selectedPetIds)")
        
        walkMemberSercice.fetchWalkAvailableMember(petId: selectedPetIds, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    self.memberList = response.result!.members
                    self.choosePersonView.personCollectionView.reloadData()
                    choosePersonView.chooseSaveBtn.addTarget(self, action: #selector(savePersonBtnTapped), for: .touchUpInside)
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("산책 가능한 멤버 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    

    // 산책 시작 화면으로 넘어감
    @objc private func savePersonBtnTapped() {
        
        self.selectedMembers = choosePersonView.personCollectionView.indexPathsForSelectedItems?
            .compactMap { $0.item < memberList.count ? memberList[$0.item] : nil } ?? []
        

        removeView(ChoosePersonView.self)
        let walkingVC = WalkingViewController()
        
        // 산책멤버, 펫 정보 같이 넘겨줌
        walkingVC.selectedPets = self.selectedPets
        walkingVC.selectedMembers = self.selectedMembers
        walkingVC.selectedAllItems = selectedPets.map { SelectedAllItems.pet($0) } +
                                     selectedMembers.map { SelectedAllItems.member($0) }
        print("\(walkingVC.selectedAllItems)")
        
        walkingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(walkingVC, animated: true)
    }
    



// MARK: 네이버지도
extension MapViewController: CLLocationManagerDelegate, LocationHandling {
    var mapContainer: MapView { mapView }

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


// MARK: 추천 경로에 대한 메소드
extension MapViewController {
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
          switch gesture.state {
          
          // 제스처가 끝났을때 확장/축소 결정
          case .ended:
              if !isExpanded {
                  fetchRouteData(reset: true, sort: "RECOMMEND")
              }
              
              let velocity = gesture.velocity(in: mapView.recommendRouteView).y  // 초당 픽셀 이동 속도
              if velocity < -500 { // 위로 빠르게 스와이프 -> 확장
                  isExpanded = true
              } else if velocity > 500 { // 아래로 빠르게 스와이프 -> 축소
                  isExpanded = false
              }
              
              let finalHeight = isExpanded ? maxHeight : minHeight
              mapView.recommendRouteView.snp.updateConstraints { make in
                  make.height.equalTo(finalHeight)
              }
              
              // 높이에 따라 버튼 숨기기
              mapView.petStoreButton.isHidden = isExpanded
              mapView.vetButton.isHidden = isExpanded
              mapView.recommendRouteLabel.isHidden = !isExpanded
              mapView.routeFilterButton.isHidden = !isExpanded
              mapView.recommendRouteTableView.isHidden = !isExpanded
              
              UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
              }
          default:
              break
          }
      }
    
    // 정렬을 위한 팝업버튼
    private func configRouteFilterButton() {
        let popUpButtonClosure = { (action: UIAction) in
            if action.title == "추천순" {
                self.mapView.routeFilterButton.setTitle("추천순", for: .normal)
                
            } else if action.title == "거리순" {
                self.mapView.routeFilterButton.setTitle("거리순", for: .normal)
                
            } else if action.title == "소요 시간순" {
                self.mapView.routeFilterButton.setTitle("소요 시간순", for: .normal)
            }
            
            self.mapView.recommendRouteTableView.reloadData()
        }
        
        mapView.routeFilterButton.menu = UIMenu(title: "정렬", children: [
            UIAction(title: "추천순", handler: popUpButtonClosure),
            UIAction(title: "거리순", handler: popUpButtonClosure),
            UIAction(title: "소요 시간순", handler: popUpButtonClosure),
        ])
        
        mapView.routeFilterButton.showsMenuAsPrimaryAction = true
    }
    
    
    private func fetchRouteData(reset: Bool = false, sort: String) {
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        if isFetching { return }
        isFetching = true
        
        if reset {
            cursor = 0
            hasNext = true
            recommendRoutes.removeAll()
            mapView.recommendRouteTableView.reloadData()
        }
        
        walkRecommendService.fetchWalkRecommends(sort: sort, cursor: cursor, size: 10, token: token){ [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let response):
                if response.isSuccess {
                    if let routeList = response.result {
                        self.recommendRoutes.append(contentsOf: routeList.items!)
                        
                        print("추천 경로 조회 성공: \(recommendRoutes.count)")
                        self.cursor = routeList.cursor ?? 0
                        self.hasNext = routeList.hasNext
                        DispatchQueue.main.async {
                            self.mapView.recommendRouteTableView.reloadData()
                        }
                        
                    }
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("추천 경로 조회 실패: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: 추천 경로에 대한 tableView
extension MapViewController: UITableViewDelegate, UITableViewDataSource, RecommendRouteTableViewCellDelegate {
    
    // 셀 등록
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recommendRoutes = recommendRoutes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendRouteTableViewCell", for: indexPath) as! RecommendRouteTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: recommendRoutes)
        cell.delegate = self
        

        return cell
    }
    
    func likeButtonTapped(in cell: RecommendRouteTableViewCell) {
        guard let indexPath = mapView.recommendRouteTableView.indexPath(for: cell) else { return }

        let route = recommendRoutes[indexPath.row]
        print("\(route.id)")
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        walkRecommendService.likeWalkRecommend(walkId: route.id, token: token){ [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if response.isSuccess {

                    DispatchQueue.main.async {
                        self.mapView.recommendRouteTableView.reloadRows(at: [indexPath], with: .none)
                    }
                } else {
                    print("서버 응답 에러: \(response.message)")
                }
            case .failure(let error):
                print("게시글 좋아요 실패: \(error.localizedDescription)")
            }
        }
        
    }
    
    // 셀 갯수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recommendRoutes.count
    }
    
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 + 20
    }
    
    // 셀 선택 아예 못하게 막기
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}



// MARK: 산책 멤버 선택에 대한 collectionView
extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseProfileViewCell", for: indexPath) as? ChooseProfileViewCell else {
            return UICollectionViewCell()
        }

        if collectionView == chooseDogView.dogCollectionView {
            let pet = petList[indexPath.item]
            cell.configurePet(with: pet)
        } else if collectionView == choosePersonView.personCollectionView {
            let member = memberList[indexPath.item]
            cell.configureMember(with: member)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 셀을 선택하면 자동으로 cell.isSelected = true로 설정하고 셀 네부의 isSelected의 didSet이 실행되기 때문에
        // indexPathsForSelectedItems 로 선택된 셀 확인 가능
        let hasSelection = !(collectionView.indexPathsForSelectedItems?.isEmpty ?? true)
        updateSaveBtn(isEnabled: hasSelection)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let hasSelection = !(collectionView.indexPathsForSelectedItems?.isEmpty ?? true)
        updateSaveBtn(isEnabled: hasSelection)
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == chooseDogView.dogCollectionView {
            return petList.count
        } else if collectionView == choosePersonView.personCollectionView {
            return memberList.count
        }
        return 0
    }
    
    // 셀선택.해제시 다음 버튼 활성화 함수
    private func updateSaveBtn(isEnabled: Bool) {
        let color: UIColor = isEnabled ? .blue01 : .gray03
        chooseDogView.chooseSaveBtn.backgroundColor = color
        chooseDogView.chooseSaveBtn.isEnabled = isEnabled
        choosePersonView.chooseSaveBtn.backgroundColor = color
        choosePersonView.chooseSaveBtn.isEnabled = isEnabled
    }
}


// MARK: View 띄우기 및 삭제
extension MapViewController {
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
            // dimmedView 생성
            let dimmedView = UIView(frame: window.bounds)
            dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            // 배경 터치 시 popToRootViewController
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
            dimmedView.addGestureRecognizer(tapGesture)
            
            // 실제 띄우고 싶은 뷰 생성
            let view = T()
            window.addSubview(dimmedView)
            window.addSubview(view)
            view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            return view
        }
        return T()
    }
    
    @objc private func dimmedViewTapped() {
        // 모든 dimmed 및 선택 뷰 제거
        removeView(ChooseDogView.self)
        removeView(ChoosePersonView.self)
    }
}
