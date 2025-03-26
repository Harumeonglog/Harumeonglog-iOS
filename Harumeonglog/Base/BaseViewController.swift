//
//  BaseViewControllers.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/13/25.
//

import UIKit

// 탭바 커스텀 (높이 설정)
class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 100
        return size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseViewController: UITabBarController {
    
    private let homeVC = UINavigationController(rootViewController: HomeViewController())
    private let walkingVC = UINavigationController(rootViewController: MapViewController())
    private lazy var photosVC: UINavigationController = {
        let defaultAlbum = Album(
            coverImage: UIImage(named: "defaultImage") ?? UIImage(),
            images: [],
            name: "기본 앨범",
            photosCount: 0
        )
        return UINavigationController(rootViewController: PhotosViewController(album: defaultAlbum))
    }()
    private let socialVC = UINavigationController(rootViewController: SocialViewController())
    private let myPageVC = UINavigationController(rootViewController: MyPageViewController())
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        setupTabBar()
        self.viewControllers = [homeVC, walkingVC, photosVC, socialVC, myPageVC]
    }
    
    override func loadView() {
        super.loadView()
        setValue(CustomTabBar(), forKey: "tabBar")
    }
    
    private func setupTabBarItems() {
        let iconSizeHome = CGSize(width: 31, height: 31)
        let iconSizeWalking = CGSize(width: 31, height: 31)
        let iconSizePhoto = CGSize(width: 24, height: 24)
        let iconSizeFriends = CGSize(width: 25, height: 20)
        let iconSizeMyPage = CGSize(width: 27, height: 27)
        
        let insets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        homeVC.tabBarItem = createTabBarItem(title: "홈", image: .home, tag: 0, size: iconSizeHome, insets: insets)
        walkingVC.tabBarItem = createTabBarItem(title: "산책", image: .dogWalking, tag: 1, size: iconSizeWalking, insets: insets)
        photosVC.tabBarItem = createTabBarItem(title: "사진", image: .photo, tag: 2, size: iconSizePhoto, insets: insets)
        socialVC.tabBarItem = createTabBarItem(title: "소셜", image: .friends, tag: 3, size: iconSizeFriends, insets: insets)
        myPageVC.tabBarItem = createTabBarItem(title: "마이페이지", image: .gear, tag: 4, size: iconSizeMyPage, insets: insets)
    }
    
    private func createTabBarItem(title: String, image: UIImage, tag: Int, size: CGSize, insets: UIEdgeInsets) -> UITabBarItem {
        let resizedImage = image.withRenderingMode(.alwaysOriginal)
            .resizableImage(withCapInsets: .zero, resizingMode: .stretch)
            .resized(to: size)
        
        let tabBarItem = UITabBarItem(title: title, image: resizedImage, tag: tag)
        tabBarItem.imageInsets = insets
        return tabBarItem
    }
    
    private func setupTabBar() {
        // 선택 아이템 색상
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray02
        
        // 배경 색상
        tabBar.backgroundColor = .bg
    }

}
