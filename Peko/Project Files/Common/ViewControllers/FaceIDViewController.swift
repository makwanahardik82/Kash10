//
//  FaceIDViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 26/03/24.
//

import UIKit
import LocalAuthentication

class FaceIDViewController: MainViewController {
    
    @IBOutlet weak var firstNameLabel: PekoLabel!
    static func storyboardInstance() -> FaceIDViewController? {
        return AppStoryboards.FaceID.instantiateViewController(identifier: "FaceIDViewController") as? FaceIDViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.firstNameLabel.text = "Welcome back " + (objUserSession.profileDetail?.name ?? "")
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
       // self.faceIDButtonClick(UIButton())
    }
    @IBAction func faceIDButtonClick(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.login()
                    } else {
                        // error
                        
                        //                            let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        //                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                        //                            self!.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry
            print("NO")
        }
    }
    
    // MARK: -
    @IBAction func loginWithPasswordButtonClick(_ sender: Any) {
        if let objLoginVC = LoginViewController.storyboardInstance(){
            self.navigationController?.pushViewController(objLoginVC, animated: true)
        }
    }
    
    // MARK: - Create Account
    @IBAction func createAccountButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        if let signupVC = CreateAccountViewController.storyboardInstance() {
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
    // MARK: - Help & Support
    @IBAction func helpAndSupportButtonClick(_ sender: Any) {
        self.supportMail()
    }
    
    
    func login(){
        HPProgressHUD.show()
        
        let userName = UserDefaults.standard.string(forKey: Constants.kSavedUserName) ?? ""
        let password = UserDefaults.standard.string(forKey: Constants.kSavedPassword) ?? ""
        
        let loginRequest = LoginRequest(email: userName, password: password)
        
        HPProgressHUD.show()
       
        LoginViewModel().userLogin(loginRequest: loginRequest) { response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                   
                    objUserSession.is_login = true
                    
                    objUserSession.user_id = response?.data?.id ?? "0"
                    objUserSession.username = response?.data?.username ?? ""
                    objUserSession.token = response?.data?.token ?? ""
                    objUserSession.role = response?.data?.role ?? ""
                    
                    
                    objShareManager.navigateToViewController = .TabBarVC
                    self.navigationController?.popToRootViewController(animated: false)
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
}
