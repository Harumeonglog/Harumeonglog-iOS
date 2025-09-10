//
//  MapViewController+Recommend.swift
//  Harumeonglog
//
//  Created by 김민지 on 7/17/25.
//

import UIKit
import NMapsMap
import CoreLocation

// MARK: 추천 경로에 대한 메소드
extension MapViewController {
    
    func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshRecommendRoutes), for: .valueChanged)
        mapView.recommendRouteTableView.refreshControl = refreshControl
    }

    @objc private func refreshRecommendRoutes() {
        print("새로고침 실행")
        
        if mapView.routeFilterButton.titleLabel?.text == "추천순" {
            fetchRouteData(reset: true, sort: "RECOMMEND")
        } else if mapView.routeFilterButton.titleLabel?.text == "거리순" {
            fetchRouteData(reset: true, sort: "DISTANCE")
            
        } else if mapView.routeFilterButton.titleLabel?.text == "소요 시간순" {
            fetchRouteData(reset: true, sort: "TIME")
        }
        mapView.recommendRouteTableView.refreshControl?.endRefreshing()
    }
    
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
            updateRecommendRouteUI()
        default:
            break
        }
    }
    
    // 정렬을 위한 팝업버튼
    func configRouteFilterButton() {
        let popUpButtonClosure: (UIAction) -> Void = { [weak self] action in
            guard let self else { return }

            if action.title == "추천순" {
                self.mapView.routeFilterButton.setTitle("추천순", for: .normal)
                fetchRouteData(reset: true, sort: "RECOMMEND")
            } else if action.title == "거리순" {
                self.mapView.routeFilterButton.setTitle("거리순", for: .normal)
                fetchRouteData(reset: true, sort: "DISTANCE")
            } else if action.title == "소요 시간순" {
                self.mapView.routeFilterButton.setTitle("소요 시간순", for: .normal)
                fetchRouteData(reset: true, sort: "TIME")
            }
        }

        let recommendAction = makeAction(title: "추천순", color: .gray00, handler: popUpButtonClosure)
        let distanceAction = makeAction(title: "거리순", color: .gray00, handler: popUpButtonClosure)
        let timeAction = makeAction(title: "소요 시간순", color: .gray00, handler: popUpButtonClosure)

        mapView.routeFilterButton.menu = UIMenu(title: "정렬", children: [
            recommendAction,
            distanceAction,
            timeAction
        ])
        mapView.routeFilterButton.showsMenuAsPrimaryAction = true
    }

    
    
    func fetchRouteData(reset: Bool = false, sort: String) {
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
                }
            case .failure(let error):
                print("추천 경로 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func updateRecommendRouteUI() {
        // 높이에 따라 버튼 숨기기
        mapView.petStoreButton.isHidden = isExpanded
        mapView.vetButton.isHidden = isExpanded
        mapView.recommendRouteLabel.isHidden = !isExpanded
        mapView.routeFilterButton.isHidden = !isExpanded
        mapView.recommendRouteTableView.isHidden = !isExpanded
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: 추천 경로에 대한 tableView
extension MapViewController: UITableViewDelegate, UITableViewDataSource, RecommendRouteTableViewCellDelegate {
    
    // 셀 등록
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let route = recommendRoutes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendRouteTableViewCell", for: indexPath) as! RecommendRouteTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: route)
        cell.delegate = self
        
        return cell
    }
    
    func cellDoubleTapped(in cell: RecommendRouteTableViewCell) {
        sendLikeToServer(in: cell)
    }
    
    func likeButtonTapped(in cell: RecommendRouteTableViewCell) {
        sendLikeToServer(in: cell)
    }
    
    private func sendLikeToServer(in cell: RecommendRouteTableViewCell) {
        guard let indexPath = mapView.recommendRouteTableView.indexPath(for: cell) else { return }
        
        let route = recommendRoutes[indexPath.row]
        print("\(route.id)")
        
        guard let token = KeychainService.get(key: K.Keys.accessToken) else { return }
        
        walkRecommendService.likeWalkRecommend(walkId: route.id, token: token){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isSuccess {
                    self.recommendRoutes[indexPath.row].isLike.toggle()

                    if self.recommendRoutes[indexPath.row].isLike {
                        self.recommendRoutes[indexPath.row].walkLikeNum += 1
                    } else {
                        self.recommendRoutes[indexPath.row].walkLikeNum -= 1
                    }
                    
                    DispatchQueue.main.async {
                        self.mapView.recommendRouteTableView.reloadRows(at: [indexPath], with: .none)
                    }
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
