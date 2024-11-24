//
//  TabBarViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    //var customTabBarView = UIView(frame: .zero)
        
    static func storyboardInstance() -> TabBarViewController? {
        return AppStoryboards.Main.instantiateViewController(identifier: "TabBarViewController") as? TabBarViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.unselectedItemTintColor = .gray// AppColors.redThemeColor
        self.navigationController?.isNavigationBarHidden = true
      
        
        if #available(iOS 15.0, *) {
           let appearance = UITabBarAppearance()
           appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = .lightGray
           self.tabBar.standardAppearance = appearance
           self.tabBar.scrollEdgeAppearance = appearance // tabBar.standardAppearance
        }
        self.delegate = self
        
        
        if objShareManager.appTarget == .PekoUAE {
            self.tabBar.tintColor = .redButtonColor // AppColors.redThemeColor
            self.viewControllers = [homeTabBar, notificationTabBar, centerTabBar, transactionTabBar, settingTabBar]
            
            if let tbbar = self.tabBar as? CustomTabBar {
                tbbar.didTapButton = { [unowned self] in
                 //   self.selectedIndex = 2
                }
            }
            
        }else{
            self.tabBar.tintColor = .black // AppColors.redThemeColor
            self.viewControllers = [homeTabBar, transactionTabBar, settingTabBar]
        }
    }
    
    lazy public var homeTabBar: UINavigationController = {
        
        let homeVC = HomeViewController.storyboardInstance()
        
        var title = ""
        if objShareManager.appTarget == .PekoUAE {
            title = "Home"
        }else{
            title = ""
        }
        
        let defaultImage = UIImage(named: "icon_tab_home")!.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "icon_tab_home")!.withRenderingMode(.alwaysTemplate)
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)
        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        homeVC!.tabBarItem = tabBarItem
        
        let nav = CustomNavigationController(rootViewController: homeVC!)
//        nav.navigationBar.isTranslucent = false
        return nav
        
    }()
    
    lazy public var transactionTabBar: UINavigationController = {
        let homeVC = TransactionsViewController.storyboardInstance()
        
        var title = ""
        if objShareManager.appTarget == .PekoUAE {
            title = "Transactions"
        }else{
            title = ""
        }
        
        let defaultImage = UIImage(named: "icon_tab_transaction")!.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: "icon_tab_transaction")!.withRenderingMode(.alwaysTemplate)
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)
        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        homeVC!.tabBarItem = tabBarItem
        
        let nav = CustomNavigationController(rootViewController: homeVC!)
        nav.navigationBar.isTranslucent = false
        return nav
    }()
    // MARK: -
    lazy public var notificationTabBar: UINavigationController = {
        let homeVC = OffersViewController.storyboardInstance()
        
        var title = "Offers"
        
        let defaultImage = UIImage(named: "icon_tab_offer")!.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: "icon_tab_offer")!.withRenderingMode(.alwaysTemplate)
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)
        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
      //  tabBarItem.badgeValue = "New"
        homeVC!.tabBarItem = tabBarItem
        
        
        let nav = CustomNavigationController(rootViewController: homeVC!)
        nav.navigationBar.isTranslucent = false
        return nav
    }()
    // MARK: -
    lazy public var centerTabBar: UINavigationController = {
        let homeVC = PekoClubViewController.storyboardInstance()
        
        var title = "My Kash10"
        
        let defaultImage = UIImage(named: "")//!.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: "") // !.withRenderingMode(.alwaysTemplate)
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: defaultImage)
        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        homeVC!.tabBarItem = tabBarItem
        
        let nav = CustomNavigationController(rootViewController: homeVC!)
        nav.navigationBar.isTranslucent = false
        return nav
    }()
    
    lazy public var settingTabBar: UINavigationController = {
        let homeVC = SettingsViewController.storyboardInstance()
        
        var title = ""
        if objShareManager.appTarget == .PekoUAE {
            title = "Profile"
        }else{
            title = ""
        }
        
        let defaultImage = UIImage(named: "icon_tab_settings")!.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: "icon_tab_settings")!.withRenderingMode(.alwaysTemplate)
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)
        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        homeVC!.tabBarItem = tabBarItem
        
        let nav = CustomNavigationController(rootViewController: homeVC!)
       // nav.navigationBar.isTranslucent = false
        return nav
    }()
    
    
   
    /*
    // MARK: Private methods
    
    private func setupCustomTabBarFrame() {
        let height = self.view.safeAreaInsets.bottom + 64
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        
        self.tabBar.frame = tabFrame
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        customTabBarView.frame = tabBar.frame
    }
    
    private func setupTabBarUI() {
        // Setup your colors and corner radius
        self.tabBar.backgroundColor = UIColor.clear
        self.tabBar.cornerRadius = 30
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //            self.tabBar.backgroundColor = .fillColor
        //            self.tabBar.tintColor = .black
        //            self.tabBar.unselectedItemTintColor = UIColor.fillColor3
        //
        // Remove the line
        if #available(iOS 13.0, *) {
            let appearance = self.tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
        }
    }
   
    private func addCustomTabBarView() {
        self.customTabBarView.frame = tabBar.frame
        
        self.customTabBarView.backgroundColor = .red
        self.customTabBarView.layer.cornerRadius = 30
        self.customTabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.customTabBarView.layer.masksToBounds = false
        self.customTabBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.customTabBarView.layer.shadowOffset = CGSize(width: -4, height: -6)
        self.customTabBarView.layer.shadowOpacity = 0.5
        self.customTabBarView.layer.shadowRadius = 20
        self.tabBar.backgroundColor = .clear
        self.view.addSubview(customTabBarView)
        self.view.bringSubviewToFront(self.tabBar)
    }
    */
}
extension UITabBarController:UITabBarControllerDelegate{
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(viewController)
        
        if let nav = viewController as? UINavigationController, let vcs = nav.viewControllers as? [UIViewController] {
            if let homeVC = vcs.first as? HomeViewController {
                homeVC.getDashboardData()
            }else if let transVC = vcs.first as? TransactionsViewController {
                transVC.getTransaction()
            }
        }
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        if let nav = viewController as? UINavigationController, let vc = nav.ro
//        if viewController.isKind(of: PekoClubViewController.self) {
//           return false
//        }
        
        return true
    }
}
