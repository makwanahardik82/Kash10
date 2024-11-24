//
//  AppDelegate.swift
//  Peko
//
//  Created by Hardik Makwana on 03/01/23.
//

import UIKit
import IQKeyboardManagerSwift
import StripePayments
import Bolt
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        self.setupNavigationBar()
        
        
        Bolt.ClientProperties.shared.publishableKey = "eZ6lEBV6PBXk.sOfMj1apa2BG.039f7111be580fe9f86308960ae1b34362c0cfbf5445eafdd38d40b58edfa24f" // "3LimqK-eRwXh.FSr-EYl3MtfD.22d0658da2004799a172e868b73af0123bc07e0e41af059041ea096498725fdc"
        Bolt.ClientProperties.shared.environment = .sandbox
        
       //  STPAPIClient.shared.publishableKey = "pk_test_51Nc2NSIIbmH1gI9jiNj7GKoDEiEB1EAHOZQKE4B508wE54JVknWXtyPK6qbm7gDQoeVSGPr0agvkLctIuzkOgpOq00cGKB7NrU"
        
        
        // "pk_test_51PU6KrP2MyF7wvVDifunbsUBcdE4gvdeSUpRZJgDpUcPxeEb5g8g3v7wcwkiyvf8Nhfaf8jnPUjCCG3woEkz7hOJ00hEegr4lj"
        
      //  sk_test_51PU6KrP2MyF7wvVD9c3kVPJ00JJUtrJbicwYWDwmCsuvsPwfV1H2sQluOFfsuk7W13VWIKx8t698aibf2teZ42to00bbNFCls5
        
    //    self.setupProgressHUD()
       //  objShareManager.initializeDapiSDK()
     
#if DEBUG
       // FLEXManager.shared.showExplorer()
#endif
        
        return true
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//    }
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        
//    }
//    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
//        
//    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler:
                     @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        // This will allow us to check if we are coming from a universal link
        // and get the url with its components
        
        // The activity type (NSUserActivityTypeBrowsingWeb) is used
        // when continuing from a web browsing session to either
        // a web browser or a native app. Only activities of this
        // type can be continued from a web browser to a native app.
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL,
              let components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            return false
        }
//        let stripeHandled = StripeAPI.handleURLCallback(with: url)
//        if (!stripeHandled) {
//            // This was not a Stripe url – handle the URL normally as you would
//        }
//        
        return true
        
    }
    
    // This method handles opening custom URL schemes (for example, "your-app://stripe-redirect")
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a Stripe url – handle the URL normally as you would
        }
        return false
    }
    
    
// MARK: - Set Navigation bar
    func setupNavigationBar(){
        var color = UIColor.black // AppColors.blackThemeColor
        var tintColor = UIColor.white
        
        if objShareManager.getAppTarget() == .PekoUAE {
            color = UIColor.redButtonColor // AppColors.blackThemeColor
            tintColor = UIColor.white
        }else{
            color = UIColor.white // AppColors.blackThemeColor
            tintColor = UIColor.black
        }
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            appearance.backgroundColor = color
            appearance.titleTextAttributes = [.foregroundColor: tintColor]
            appearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }else{
            UINavigationBar.appearance().barTintColor = color // solid color
            UINavigationBar.appearance().backgroundColor = color
            //   UIBarButtonItem.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : tintColor]
        }
        UINavigationBar.appearance().tintColor = tintColor
    }
    /*
    // MARK: - Set Progress HUD
    func setupProgressHUD(){
       MKProgress.config.hudType = .radial
    //    MKProgress.config.width = 64.0
    //    MKProgress.config.height = 64.0
        MKProgress.config.hudColor = AppColors.blackThemeColor!
        MKProgress.config.backgroundColor = UIColor(white: 0, alpha: 0.55)
        MKProgress.config.cornerRadius = 25.0
        MKProgress.config.fadeInAnimationDuration = 0.2
        MKProgress.config.fadeOutAnimationDuration = 0.25
    //    MKProgress.config.hudYOffset = 15

        MKProgress.config.circleRadius = 35.0
        MKProgress.config.circleBorderWidth = 3.0
        MKProgress.config.circleBorderColor = .white
        MKProgress.config.circleAnimationDuration = 0.9
        MKProgress.config.circleArcPercentage = 0.8
        MKProgress.config.logoImage = UIImage(named: "logo_hud")
       // MKProgress.config.logoImageSize = CGSize(width: 40, height: 40)

     //   MKProgress.config.activityIndicatorStyle = .whiteLarge
       // MKProgress.config.activityIndicatorColor = .black
       // MKProgress.config.preferredStatusBarStyle = .lightContent
      //  MKProgress.config.prefersStatusBarHidden = false

    }
    */
}

