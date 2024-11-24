//
//  ForgotViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit
import PhoneCountryCodePicker


class ForgotViewController: MainViewController {

    @IBOutlet weak var flagImgView: UIImageView!
    @IBOutlet weak var phoneCodeLabel: UILabel!
    @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    var countryName = "United Arab Emirates"
    
    static func storyboardInstance() -> ForgotViewController? {
        return AppStoryboards.Login.instantiateViewController(identifier: "ForgotViewController") as? ForgotViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Forgot Password")
      //  self.mobileTxt.delegate = self
        
        DispatchQueue.main.async {
            self.phoneCodeLabel.text = objUserSession.mobileCountryCode
            let flag = PCCPViewController.image(forCountryCode: "AE")
            self.flagImgView.image = flag
        }
      //  self.emailTxt.delegate = self
        self.emailTxt.placeholder = "Account ID / Email"
    }
    
    // MARK: - Counry Button Click
    @IBAction func countryButtonClick(_ sender: Any) {
        let vc = PCCPViewController() { countryDic in
            
            if let countryDic = countryDic as? [String:Any] {
                
                if let code = countryDic["phone_code"] as? Int{
                    self.phoneCodeLabel.text = "+\(code)"
                }
                
                if let cntname = countryDic["country_en"] as? String{
                    self.countryName = cntname
                   // self.setStatesArray(country: cntname)
                }
                if let countryCode = countryDic["country_code"] as? String{
                    DispatchQueue.main.async {
                        let flag = PCCPViewController.image(forCountryCode: countryCode)
                        self.flagImgView.image = flag
                        self.mobileTxt.becomeFirstResponder()
                    }
                }
            }
        }
        vc?.tableView.tintColor = .black
        let naviVC = UINavigationController(rootViewController: vc!)
        self.present(naviVC, animated: true, completion: nil)
    }
    
    // MARK: - Send OTP
    @IBAction func sendOTPButtonClick(_ sender: Any) {
        
        if(self.emailTxt.text!.isEmpty)
        {
            self.showAlert(title: "", message: "Please enter account id / email")
        }else{
            
            HPProgressHUD.show()
            ForgotPasswordViewModel().forgotPassword(username: self.emailTxt.text!) { response, error  in
                
                HPProgressHUD.hide()
                
                if error != nil {
                    #if DEBUG
                    self.showAlert(title: "", message: error?.localizedDescription ?? "")
    #else
                    self.showAlert(title: "", message: "Something went wrong please try again")
    #endif

                }else if response?.success ?? false {
                    print("\n\n\n Forgot Password ", response?.message)
                  //  signupRequest.otp = response?.data!
                    DispatchQueue.main.async {
                        self.showAlertWithCompletion(title: "", message: response?.message ?? "") { action in
                            self.navigationController?.popViewController(animated: false)
                        }
                    }
                }else{
                    var msg = ""
                    if response?.message != nil {
                        msg = response?.message ?? ""
                    }
//                    else if response?.error?.count != nil {
//                        msg = response?.error ?? ""
//                    }
                    self.showAlert(title: "", message: msg)
                }
            }
            
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
extension ForgotViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        
        if string == " " {
            return false
        }
        if textField == self.mobileTxt {
            return textField.numberValidation(number: string)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == self.emailTxt {
//            self.passwordTxt.becomeFirstResponder()
//        }else{
//            self.loginButtonClick(UIButton())
//        }
        return true
    }
}
