//화면, 버튼, 뷰 연결

import UIKit
import Alamofire
import FSCalendar
import SnapKit

protocol ProfileSelectDelegate: AnyObject {
    func didSelectProfile(_ profile: Profile)
}

class HomeViewController: UIViewController, HomeViewDelegate {
    func changeMonth(to date: Date) {
        setCalendarTo(date: date)
    }
    
    

    let eventViewModel = HomeEventViewModel()
    let petViewModel = HomePetViewModel()

    private var hasLoadedEventDates = false

    var markedDates: [Date] = []
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    lazy var homeView: HomeView = {
        let view = HomeView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        homeView.delegate = self
        homeView.calendarView.delegate = self
        homeView.calendarView.dataSource = self

        homeView.calendarView.setCurrentPage(Date(), animated: false)
        homeView.calendarView.select(Date())

        fetchActivePets()
        petViewModel.updateActivePet(petId: 1) { _ in }
        
        setupButtons()
        updateHeaderLabel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasLoadedEventDates {
            fetchEventDatesForCurrentMonth()
            hasLoadedEventDates = true
        }
    }
    
    //
    private func fetchActivePets() {
        petViewModel.fetchActivePets { activePetsResult in
            guard let activePets = activePetsResult else { return }

            if let defaultPet = activePets.pets.first(where: { $0.petId == 1 }) {
                DispatchQueue.main.async {
                    print("선택된 반려견: \(defaultPet.name)")
                    self.homeView.nicknameLabel.text = defaultPet.name

                    if let imageUrl = URL(string: defaultPet.mainImage ?? "") {
                        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.homeView.profileButton.setImage(image, for: .normal)
                                }
                            }
                        }.resume()
                    }
                }
            }
        }
    }
    
                             
    // MARK: - 버튼 동작 함수들 모음
    private func setupButtons() {
        homeView.addeventButton.addTarget(self, action: #selector(addeventButtonTapped), for: .touchUpInside)
        homeView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        
        //헤더 누르면 년/월 선택
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        homeView.headerStackView.addGestureRecognizer(headerTap)
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCalendarSwipe(_:)))
        homeView.calendarView.addGestureRecognizer(swipeGesture)

        homeView.profileButton.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
    }

    @objc func addeventButtonTapped() {
        let addVC = AddEventViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }

    @objc func alarmButtonTapped() {
        let notificationVC = NotiViewController()
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc private func headerTapped() {
        print("헤더 탭 감지됨")
        showMonthYearPicker()
    }
    
    @objc private func handleCalendarSwipe(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: homeView.calendarView).y
        if gesture.state == .ended {
            if velocity < -300 {
                homeView.calendarView.setScope(.week, animated: true)
            } else if velocity > 300 {
                homeView.calendarView.setScope(.month, animated: true)
            }
        }
    }

    private func getCurrentMonthString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }

    func updateHeaderLabel() {
        homeView.headerLabel.text = getCurrentMonthString(for: homeView.calendarView.currentPage)
    }

    func fetchEventDatesForCurrentMonth() {
        let currentDate = homeView.calendarView.currentPage
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)

        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 없음")
            return
        }

        self.eventViewModel.fetchEventDates(year: year, month: month, token: token) { result in
            switch result {
            case .success(let dates):
                self.markedDates = dates
                DispatchQueue.main.async {
                    self.homeView.calendarView.reloadData()
                    print("이벤트 날짜 조회 성공")
                }
            case .failure(let error):
                print("이벤트 날짜 조회 실패: \(error)")
            }
        }
    }

    func setCalendarTo(date: Date) {
        homeView.calendarView.setCurrentPage(date, animated: true)
        updateHeaderLabel()
    }
}


// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 이벤트 목록 중 선택된 index의 eventId를 전달
        let editVC = EditEventViewController(eventId: indexPath.row + 1)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}
