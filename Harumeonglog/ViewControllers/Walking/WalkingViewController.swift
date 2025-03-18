//
//  ViewController.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit
import NMapsMap
import CoreLocation

class WalkingViewController: UIViewController {
    
    private var isExpanded = false  // 추천 경로 모달창 expand 상태를 나타내는 변수
    private let minHeight: CGFloat = 150
    private let maxHeight: CGFloat = 750
    
    private lazy var walkingView: WalkingView = {
        let view = WalkingView()
        
        view.moveToUserLocationButton.addTarget(self, action: #selector(moveToUserLocationButtonTapped), for: .touchUpInside)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.recommendRouteView.addGestureRecognizer(panGesture)  // 슬라이드 제스처
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.walkingView
        
        walkingView.recommendRouteTableView.delegate = self
        walkingView.recommendRouteTableView.dataSource = self
    
    }
    
    // 현재 위치로 이동하는 함수
    @objc func moveToUserLocationButtonTapped() {
        
    }
    
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
          let translation = gesture.translation(in: walkingView.recommendRouteView)
          
          switch gesture.state {
          
          // 제스처가 끝났을때 확장/축소 결정
          case .ended:
              let velocity = gesture.velocity(in: walkingView.recommendRouteView).y  // 초당 픽셀 이동 속도
              if velocity < -500 { // 위로 빠르게 스와이프 -> 확장
                  isExpanded = true
              } else if velocity > 500 { // 아래로 빠르게 스와이프 -> 축소
                  isExpanded = false
              }
              
              let finalHeight = isExpanded ? maxHeight : minHeight
              walkingView.recommendRouteView.snp.updateConstraints { make in
                  make.height.equalTo(finalHeight)
              }
              
              // 높이에 따라 버튼 숨기기
              walkingView.petStoreButton.isHidden = isExpanded
              walkingView.vetButton.isHidden = isExpanded
              walkingView.recommendRouteLabel.isHidden = !isExpanded
              walkingView.routeFilterButton.isHidden = !isExpanded
              walkingView.recommendRouteTableView.isHidden = !isExpanded
              
              UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
              }
              
          default:
              break
          }
      }
}

extension WalkingViewController: UITableViewDelegate, UITableViewDataSource {
    // 셀 등록
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendRouteTableViewCell") as? RecommendRouteTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    // 셀 갯수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 + 10
    }
    
    // 셀 선택 아예 못하게 막기
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

