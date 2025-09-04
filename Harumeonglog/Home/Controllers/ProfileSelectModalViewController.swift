//
//  ProfileSelectModalViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/2/25.
//

// ProfileSelectionModalViewController.swift
import UIKit

class ProfileSelectModalViewController: UIViewController {
    
    var profiles: [Profile] = [] {
        didSet {
            profileSelectModalView.collectionView.reloadData()
        }
    }
    
    public var selectedProfile: Profile?
    
    private lazy var profileSelectModalView: ProfileSelectModalView = {
        let view = ProfileSelectModalView()
        return view
    }()
    
    weak var delegate: ProfileSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = profileSelectModalView
        self.view.backgroundColor = .white
        
        profileSelectModalView.collectionView.delegate = self
        profileSelectModalView.collectionView.dataSource = self
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [
                .custom { _ in 250},
                .large()
            ]
            sheet.prefersGrabberVisible = true // 상단에 그랩바 표시
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .large
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadProfiles()
    }
    
    public func loadProfiles() {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken), !accessToken.isEmpty else {
            print("AccessToken이 존재하지 않음")
            return
        }

        // 먼저 현재 활성 펫 정보 가져오기
        PetService.ActivePetInfo(token: accessToken) { [weak self] activePetResult in
            switch activePetResult {
            case .success(let activePetResponse):
                if let activePetInfo = activePetResponse.result {
                    print("현재 활성 펫 정보: \(activePetInfo.name) (ID: \(activePetInfo.petId))")
                    
                    // 활성 펫 목록 가져오기
                    PetService.fetchActivePets(token: accessToken) { result in
                        switch result {
                        case .success(let response):
                            switch response.result {
                            case .result(let activePetsResult):
                                self?.profiles = activePetsResult.pets.map { pet in
                                    let imageName = self?.validateImageURL(pet.mainImage) ?? ""
                                    return Profile(petId: pet.petId, name: pet.name, imageName: imageName)
                                }
                                
                                // 현재 활성 펫을 selectedProfile로 설정
                                let activeImageName = self?.validateImageURL(activePetInfo.mainImage) ?? ""
                                self?.selectedProfile = Profile(
                                    petId: activePetInfo.petId, 
                                    name: activePetInfo.name, 
                                    imageName: activeImageName
                                )
                                
                                // UI 업데이트
                                DispatchQueue.main.async {
                                    self?.profileSelectModalView.collectionView.reloadData()
                                }
                                
                            case .message(let msg):
                                print("서버 메시지:", msg)
                            case .none:
                                print("result가 없습니다.")
                            }
                        case .failure(let error):
                            print("반려동물 목록 불러오기 실패:", error)
                        }
                    }
                }
            case .failure(let error):
                print("현재 활성 펫 정보 가져오기 실패:", error)
                
                // 실패 시 기본값으로 petId: 1 사용
                PetService.fetchActivePets(token: accessToken) { result in
                    switch result {
                    case .success(let response):
                        switch response.result {
                        case .result(let activePetsResult):
                            self?.profiles = activePetsResult.pets.map { pet in
                                let imageName = self?.validateImageURL(pet.mainImage) ?? ""
                                return Profile(petId: pet.petId, name: pet.name, imageName: imageName)
                            }
                            
                            // 기본값으로 첫 번째 펫 선택
                            if let firstPet = activePetsResult.pets.first {
                                let imageName = self?.validateImageURL(firstPet.mainImage) ?? ""
                                self?.selectedProfile = Profile(
                                    petId: firstPet.petId, 
                                    name: firstPet.name, 
                                    imageName: imageName
                                )
                            }
                            
                            DispatchQueue.main.async {
                                self?.profileSelectModalView.collectionView.reloadData()
                            }
                            
                        case .message(let msg):
                            print("서버 메시지:", msg)
                        case .none:
                            print("result가 없습니다.")
                        }
                    case .failure(let error):
                        print("반려동물 목록 불러오기 실패:", error)
                    }
                }
            }
        }
    }
    
    // 이미지 URL 유효성 검사
    private func validateImageURL(_ imageURL: String?) -> String {
        guard let url = imageURL, !url.isEmpty else { return "" }
        
        // 유효하지 않은 값들 필터링
        if url == "string" || url == "null" || url == "undefined" {
            return ""
        }
        
        // 경로가 /string 으로 끝나는 잘못된 URL 방지
        if let u = URL(string: url) {
            let last = u.lastPathComponent.lowercased()
            if last == "string" || last == "null" || last == "undefined" {
                return ""
            }
            return url
        }
        
        return ""
    }
}


extension ProfileSelectModalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // UICollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileSelectCollectionViewCell
        let profile = profiles[indexPath.item]
        let isSelected = selectedProfile?.petId == profile.petId
        
        print("ProfileSelectModalViewController - cellForItemAt:")
        print("  profile: \(profile.name) (ID: \(profile.petId))")
        print("  selectedProfile: \(selectedProfile?.name ?? "nil") (ID: \(selectedProfile?.petId ?? -1))")
        print("  isSelected: \(isSelected)")
        
        cell.configure(with: profile, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProfile = profiles[indexPath.item]
        self.selectedProfile = selectedProfile
        // delegate 호출
        delegate?.didSelectProfile(selectedProfile)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileSelectModalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let horizontalInset: CGFloat = 20 * 2
        let interItemSpacing: CGFloat = 12
        let totalSpacing = horizontalInset + (columns - 1) * interItemSpacing
        let width = floor((collectionView.bounds.width - totalSpacing) / columns)
        return CGSize(width: width, height: 120)
    }
}
