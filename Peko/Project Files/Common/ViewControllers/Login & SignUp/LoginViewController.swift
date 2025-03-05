//
//  LoginViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 07/12/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTxt: PekoTextField!
    
    @IBOutlet weak var passwordTxt: PekoTextField!
    
    //    @IBOutlet weak var userNameView: PekoFloatingTextFieldView!
//    @IBOutlet weak var passwordView: PekoFloatingTextFieldView!
//    
    
    static func storyboardInstance() -> LoginViewController? {
        return AppStoryboards.Login.instantiateViewController(identifier: "LoginViewController") as? LoginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.animationView.setGIF(gifName: "Login_Logo.gif", loopCount: -1)
#if DEBUG
        if is_live {
            self.userNameTxt.text = "100000001"
            self.passwordTxt.text = "savings@123"
        }else{
            
            self.userNameTxt.text = "100000001"
            self.passwordTxt.text = "user@123" // Admin@123"
////
//            self.userNameTxt.text = "100000148"
//            self.passwordTxt.text = "123456"
           
//            self.userNameTxt.text = "100000065"
//            self.passwordTxt.text = "Peko@012"
//             
            //     "username": "100000065",
            //     "password": "Peko@012"
        }
#endif
        
    }
    override func viewWillAppear(_ animated: Bool) {
  //      self.animationView.startAnimation()
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
    //    self.animationView.stopAnimation()
    }
    
    @IBAction func eyeButtonClick(_ sender: UIButton) {
        self.passwordTxt.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    // MARK: - Login
    @IBAction func loginButtonClick(_ sender: Any) {
        self.view.endEditing(true)

        let loginRequest = LoginRequest(email: self.userNameTxt.text, password: self.passwordTxt.text)
     
        let validationResult = LoginValidation().Validate(loginRequest: loginRequest)

        if validationResult.success {
            self.view.endEditing(true)
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
                        
                        UserDefaults.standard.setValue(self.userNameTxt.text, forKey: Constants.kSavedUserName)
                        UserDefaults.standard.setValue(self.passwordTxt.text, forKey: Constants.kSavedPassword)
                        UserDefaults.standard.synchronize()
                        
                        objUserSession.is_login = true
                        
                        objUserSession.user_id = response?.data?.id ?? "0"
                        objUserSession.username = response?.data?.username ?? ""
                        objUserSession.token = response?.data?.token ?? ""
                        objUserSession.role = response?.data?.role ?? ""
                        objUserSession.sessionId = response?.data?.sessionId ?? ""
                        
                     
                        
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
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
       
    }
    // MARK: - Create Account
    @IBAction func createAccountButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        if let signupVC = CreateAccountViewController.storyboardInstance() {
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    // MARK: - Forgot Password
    @IBAction func forgotPasswordClick(_ sender: Any) {
        if let forgotVC = ForgotPasswordViewController.storyboardInstance() {
            self.navigationController?.pushViewController(forgotVC, animated: true)
        }
    }
    // MARK: - Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
