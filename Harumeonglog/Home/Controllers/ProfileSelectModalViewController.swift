//
//  ProfileSelectModalViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 4/2/25.
//

// ProfileSelectionModalViewController.swift
import UIKit

class ProfileSelectModalViewController: UIViewController {
    
    var profiles: [Profile] = [
        Profile(name: "카이", imageName: "dog1", birthDate: "2000.01.01"),
        Profile(name: "카이 2", imageName: "dog1", birthDate: "2001.02.01"),
        Profile(name: "카이 3", imageName: "dog1", birthDate: "2003.02.01"),
        Profile(name: "카이 4", imageName: "dog1", birthDate: "2004.02.01"),
        Profile(name: "카이 5", imageName: "dog1", birthDate: "2005.02.01")
    ]
    
    private lazy var profileSelectModalView: ProfileSelectModalView = {
        let view = ProfileSelectModalView()
        return view
    }()
    
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
}


extension ProfileSelectModalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // UICollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileSelectCollectionViewCell
        let profile = profiles[indexPath.item]
        cell.configure(with: profile)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProfile = profiles[indexPath.item]
        // delegate 호출
        (self.presentingViewController as? HomeViewController)?.didSelectProfile(selectedProfile)
        self.dismiss(animated: true, completion: nil)
    }
}
