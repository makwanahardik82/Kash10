//
//  MainViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit
import MessageUI
import Reachability

class MainViewController: UIViewController {

    let reachability = try! Reachability()
    var connectionLostAlert: ConnectionLostAlertUIView!
    
    var backNavigationView : BackNavigationView?
  //  var isPopToRoot = false
    
    var isBackNavigationBarView: Bool {
        set {
           // _isHeaderView = newValue
//            if newValue {  } else {
//                self.backNavigationView?.removeFromSuperview()
//                self.backNavigationView = nil
//            }
            self.setupBackNavigationBarView(isBackButton: newValue)
        }
        get { return self.isBackNavigationBarView }
    }
    
    var navigationTitleView : NavigationTitleView?
    var isNavigationTitle:Bool {
        set{
            if newValue { self.setupNavigationTitleView(isBackButton: false) } else {
                self.navigationTitleView?.removeFromSuperview()
                self.navigationTitleView = nil
            }
        }
        get { return self.isNavigationTitle }
    }
    func setupNavigationTitleView(isBackButton:Bool)  {
        self.navigationTitleView = NavigationTitleView()
     //   self.navigationTitleView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
        self.navigationTitleView?.xibSetup()
       
        self.navigationItem.titleView = self.navigationTitleView
        self.navigationTitleView?.backgroundColor = .clear
       
        self.navigationTitleView?.translatesAutoresizingMaskIntoConstraints = false
       
        self.navigationTitleView?.widthAnchor.constraint(equalToConstant: screenWidth - 50).isActive = true
        
        if isBackButton {
            self.navigationTitleView!.backButton.isHidden = false
            self.navigationTitleView?.backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        }else{
            self.navigationTitleView!.backButton.isHidden = true
        }
        
        self.navigationTitleView?.trolleyButton.addTarget(self, action: #selector(trolleyButtonClick), for: .touchUpInside)
//
    }
    
    
    // MARK: - Set Title
    func setTitle(title:String) {
        if self.backNavigationView != nil {
            self.backNavigationView?.titleLabel.text = title.localizeString()
        }else if self.navigationTitleView != nil {
            self.navigationTitleView?.titleLabel.text = title.localizeString()
        }
    }
    func getTitle() -> String {
        if self.backNavigationView != nil {
            return (self.backNavigationView?.titleLabel.text)!
        }else if self.navigationTitleView != nil {
            return (self.navigationTitleView?.titleLabel.text)!
        }
        return ""
    }
    // MARK: - Setup Back Navigation bar
    func setupBackNavigationBarView(isBackButton:Bool)  {
        self.backNavigationView = BackNavigationView()
        self.backNavigationView?.xibSetup()
     //   self.headerView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.backNavigationView!)
        
        self.backNavigationView?.translatesAutoresizingMaskIntoConstraints = false

        let margins = self.view.layoutMarginsGuide
        
        self.backNavigationView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.backNavigationView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.backNavigationView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.backNavigationView?.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
       
      //  self.backNavigationView?.backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        
        if isBackButton {
            self.backNavigationView!.backButton.isHidden = false
            self.backNavigationView?.backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        }else{
            self.backNavigationView!.backButton.isHidden = true
        }
        
        // UIApplication.shared.statusBarFrame.height
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let view1 = UIView()
        if statusBarHeight > 0 {
            //UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: statusBarHeight))
            view1.backgroundColor = .white
            self.view.addSubview(view1)
            view1.translatesAutoresizingMaskIntoConstraints = false

            view1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            view1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            
            view1.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
           // view1.heightAnchor.constraint(equalToConstant: statusBarHeight).isActive = true
              
            view1.bottomAnchor.constraint(equalTo: self.backNavigationView!.topAnchor).isActive = true
            
        }
        
        /*
        if objShareManager.getAppTarget() == .PekoUAE {
            self.backNavigationView?.containerView?.backgroundColor = .black
            view1.backgroundColor = .black
            self.backNavigationView?.titleLabel.textColor = .white
        }else if objShareManager.getAppTarget() == .PekoIndia {
            self.backNavigationView?.containerView?.backgroundColor = .white
            view1.backgroundColor = .white
            self.backNavigationView?.titleLabel.textColor = .black
        }
        */
        self.backNavigationView?.containerView?.backgroundColor = .white
        view1.backgroundColor = .white
        self.backNavigationView?.titleLabel.textColor = .black
        
        
        self.backNavigationView?.trolleyButton.addTarget(self, action: #selector(trolleyButtonClick), for: .touchUpInside)
        
        
     //   self.backNavigationView?.notificationButton.addTarget(self, action: #selector(notificationButtonClick), for: .touchUpInside)
       
    }
    
    // MARK: - Back Button Click
//    @objc func backButtonClick() {
//        if self.isPopToRoot{
//            self.navigationController?.popToRootViewController(animated: false)
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
//
//    }
    
    // MARK: -  PEKO STORE TROLLEY
    @objc func trolleyButtonClick(){
        if let trolleyVC = PekoStoreTrolleyViewController.storyboardInstance() {
            self.navigationController?.pushViewController(trolleyVC, animated: true)
        }
    }
    
    
    func supportMail() {
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.navigationBar.tintColor = UIColor.white
            
            mailComposerVC.setToRecipients([Constants.support_email])
            mailComposerVC.setSubject("\(NSLocalizedString("Feedback for App", comment: ""))")
            
            let appVersion = "App Version : \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "")"
            let osVersion = "OS Version : \(UIDevice.current.systemVersion)"
            let deviceModel = "Device Model : \(UIDevice.modelName)"
            
            let body = "\n\n\n\n\n\n\(appVersion)\n\(osVersion)\n\(deviceModel)"
            
            mailComposerVC.setMessageBody(body, isHTML: false)
            
            mailComposerVC.navigationBar.barTintColor = UIColor.white
            mailComposerVC.navigationBar.backgroundColor = UIColor.white
            
            mailComposerVC.navigationBar.tintColor = UIColor.black
            mailComposerVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
            
            self.present(mailComposerVC, animated: true, completion: { () in
                //  UIApplication.sharedApplicationtatusBarStyle = UIStatusBarStyle.LightContent
                
            })
            // self.present(mailComposerVC, animated: true, completion: nil)
            
        }
    }
    override func viewDidLoad() {
        connectionLostAlert = ConnectionLostAlertUIView()
        connectionLostAlert.clipsToBounds = true
        self.view.addSubview(connectionLostAlert)
        self.checkForInternetConnection()
    }
    // MARK: - checkForInternetConnection
    func checkForInternetConnection(){
      
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            self.connectionLostAlert.establishedConnection()
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.connectionLostAlert.show()
            
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

    }
}

// MARK: MFMailComposeViewControllerDelegate Method
extension MainViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
