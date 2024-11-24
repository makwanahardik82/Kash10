//
//  BaseViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 03/01/23.
//

import UIKit

class BaseViewController: UIViewController {

    static func storyboardInstance() -> BaseViewController? {
        return AppStoryboards.Main.instantiateViewController(identifier: "BaseViewController") as? BaseViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: "Is_App_Open_First_Time") {
            if objUserSession.is_login {
                objShareManager.navigateToViewController = .TabBarVC
               // self.getProfileDetails()
            }else{
                objShareManager.navigateToViewController = .FaceID
            }
        }else{
            objShareManager.navigateToViewController = .Onboarding
        }
        
      //  objShareManager.navigateToViewController = .TabBarVC
        
        NotificationCenter.default.addObserver(self, selector: #selector(sideBarSelectChangeView), name: NSNotification.Name(rawValue:"ChangeViewController"),
                                               object: nil)
        // Do any additional setup after loading the view.
    }
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        self.changeViewController()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func sideBarSelectChangeView() {
        navigationController?.popToRootViewController(animated: false)
    }
    func changeViewController() {
        switch objShareManager.navigateToViewController {
            
        case .Onboarding:
            if let objSubscriptionVC = OnboardingViewController.storyboardInstance(){
                self.navigationController?.pushViewController(objSubscriptionVC, animated: false)
            }
            break
            
        case .LoginVC:
            self.GoToLogingVC()
            break
        case .FaceID:
            self.GoToFaceIDVC()
            break
           
        case .TabBarVC:
            if let objTabVC = TabBarViewController.storyboardInstance(){
                self.navigationController?.pushViewController(objTabVC, animated: false)
            }
            break
        default:
            self.GoToLogingVC()
            break
        }
    }
    func GoToLogingVC()  {
        
        if let objLoginVC = LoginViewController.storyboardInstance(){
            self.navigationController?.pushViewController(objLoginVC, animated: false)
        }
    }
    
    func GoToFaceIDVC()  {
        let userName = UserDefaults.standard.string(forKey: Constants.kSavedUserName) ?? ""
        let password = UserDefaults.standard.string(forKey: Constants.kSavedPassword) ?? ""
        
        if userName.count == 0 || password.count == 0 {
            self.GoToLogingVC()
        }else{
            if let faceIDVC = FaceIDViewController.storyboardInstance() {
                self.navigationController?.pushViewController(faceIDVC, animated: true)
            }
        }
    }
}

