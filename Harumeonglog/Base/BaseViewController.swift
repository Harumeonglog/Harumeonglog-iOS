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
        var newSize = super.sizeThatFits(size)
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        let homeButtonResolutions: [CGSize] = [
            CGSize(width: 320, height: 568),  // iPhone SE (1st gen)
            CGSize(width: 375, height: 667),  // iPhone 6s, 7, 8, SE (2nd/3rd gen)
            CGSize(width: 414, height: 736),  // iPhone 6s Plus, 7 Plus, 8 Plus
        ]

        if homeButtonResolutions.contains(CGSize(width: screenWidth, height: screenHeight)) {
            newSize.height = 60
        } else {
            newSize.height = 100
        }
        
        return newSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let fcmToken = KeychainService.get(key: K.Keys.fcmToken) else {
            print("fcmToken not found")
            return
        }
        FCMViewModel().sendFCM(fcm: String(describing: fcmToken))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseViewController: UITabBarController {
    
    private let homeVC = UINavigationController(rootViewController: HomeViewController())
    private let walkingVC = UINavigationController(rootViewController: MapViewController())
    private lazy var photosVC = UINavigationController(rootViewController: PhotoAlbumsViewController())
    private let socialVC = UINavigationController(rootViewController: SocialViewController())
    private let myPageVC = UINavigationController(rootViewController: MyPageViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        setupTabBar()
        MemberAPIService.getInfo{ _,_  in }
        self.view.backgroundColor = .bg
        myPageVC.navigationBar.backgroundColor = .bg
        homeVC.navigationBar.isHidden = true
        photosVC.navigationBar.isHidden = true
        socialVC.navigationBar.isHidden = true
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
        
        homeVC.tabBarItem = createTabBarItem(title: "", image: .home, tag: 0, size: iconSizeHome, insets: insets)
        walkingVC.tabBarItem = createTabBarItem(title: "", image: .dogWalking, tag: 1, size: iconSizeWalking, insets: insets)
        photosVC.tabBarItem = createTabBarItem(title: "", image: .photo, tag: 2, size: iconSizePhoto, insets: insets)
        socialVC.tabBarItem = createTabBarItem(title: "", image: .friends, tag: 3, size: iconSizeFriends, insets: insets)
        myPageVC.tabBarItem = createTabBarItem(title: "", image: .gear, tag: 4, size: iconSizeMyPage, insets: insets)
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
        // Item tint colors
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray02

        // Opaque background for iOS 15+, including scroll edge
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .bg
            // appearance.shadowColor = .clear

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = .bg
            tabBar.backgroundColor = .bg
        }

        tabBar.isTranslucent = false
    }
    
}
