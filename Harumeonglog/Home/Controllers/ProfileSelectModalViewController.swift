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
                        .custom { _ in 250 }]
            sheet.prefersGrabberVisible = true // 상단에 그랩바 표시
        }
        
    }
    
    public func loadProfiles() {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken), !accessToken.isEmpty else {
            print("AccessToken이 존재하지 않음")
            return
        }

        PetService.fetchActivePets(token: accessToken) { result in
            switch result {
            case .success(let response):
                switch response.result {
                case .result(let activePetsResult):
                    self.profiles = activePetsResult.pets.map {
                        Profile(petId: $0.petId, name: $0.name, imageName: $0.mainImage ?? "")
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


extension ProfileSelectModalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // UICollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileSelectCollectionViewCell
        let profile = profiles[indexPath.item]
        let isSelected = selectedProfile?.name == profile.name
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
