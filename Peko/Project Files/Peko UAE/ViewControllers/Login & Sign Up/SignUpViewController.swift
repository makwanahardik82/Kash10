//
//  SignUpViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit
import PhoneCountryCodePicker


class SignUpViewController: MainViewController {

    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var companyNameTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var sectorTxt: UITextField!
    
    @IBOutlet weak var flagImgView: UIImageView!
    @IBOutlet weak var phoneCodeLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    
    var countryName = "United Arab Emirates"
   
    
    static func storyboardInstance() -> SignUpViewController? {
        return AppStoryboards.SignUp.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Welcome to Peko\nLet’s create an account")
        
        self.backNavigationView?.titleLabel.textAlignment = .center
        self.backNavigationView?.titleLabel.font = AppFonts.Bold.size(size: 15)
        
        DispatchQueue.main.async {
            self.phoneCodeLabel.text = objUserSession.mobileCountryCode
            let flag = PCCPViewController.image(forCountryCode: "AE")
            self.flagImgView.image = flag
        }
        
        self.termsLabel.attributedText = NSMutableAttributedString().color(.black, "I verify that I am an authorized representative of this organization and have the right to act on its behalf in the creation and management of this account. The organization and I agree to the additional terms of Peko. ", font: AppFonts.Regular.size(size: 10)).underline(.black, "Terms and conditions", font: AppFonts.SemiBold.size(size: 10))
        
        
        self.mobileTxt.delegate = self
        
     //   self.passwordTxt.delegate = self
        self.passwordTxt.isSecureTextEntry = true
      
       // self.confirmPasswordTxt.delegate = self
        self.confirmPasswordTxt.isSecureTextEntry = true
      
        // Do any additional setup after loading the view.
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
        naviVC.modalPresentationStyle = .fullScreen
        self.present(naviVC, animated: true, completion: nil)
    }
// MARK: - Check Button Click
    @IBAction func checkButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
   
    @IBAction func termsConditionButtonClick(_ sender: Any) {
        self.openURL(urlString: Constants.terms_url)
    }
    
    // MARK: - City Button Click
    @IBAction func cityButtonClick(_ sender: Any) {
        let pickerVC = PickerListViewController.storyboardInstance()
        pickerVC?.array = Constants.cityArray
        pickerVC?.selectedString = self.cityTxt.text!
        pickerVC?.titleString = "City"
        pickerVC?.completionBlock = { string in
            self.cityTxt.text = string
        }
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    // MARK: - Sector Button Click
    @IBAction func sectorButtonClick(_ sender: Any) {
        let pickerVC = PickerListViewController.storyboardInstance()
        pickerVC?.array = Constants.companySizeArray
        pickerVC?.selectedString = self.sectorTxt.text!
        pickerVC?.titleString = "Company Size"
        pickerVC?.completionBlock = { string in
            self.sectorTxt.text = string
        }
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        
    }
    
    // MARK: - Eye Button Click
    @IBAction func passwordEyeButtonClick(_ sender: UIButton) {
        self.passwordTxt.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
     
    }
    // MARK: - Eye Button Click
    @IBAction func confirmPasswordEyeButtonClick(_ sender: UIButton) {
        self.confirmPasswordTxt.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
     
    }
    
    // MARK: - Register Button Click
    @IBAction func registerButtonClick(_ sender: Any) {
        
        self.view.endEditing(true)
        let mobile_no = self.mobileTxt.text!
        let country_code = objUserSession.mobileCountryCode
        
        //self.phoneCodeLabel.text!.replacingOccurrences(of: "+", with: "")
        
        let signupRequest = SignUpRequest(first_name: self.firstNameTxt.text!, last_name: self.lastNameTxt.text!, mobile_number: mobile_no, company_name: self.companyNameTxt.text!, city: self.cityTxt.text!, sector: self.sectorTxt.text!, country_name: self.countryName, country_code: country_code, email: self.emailTxt.text!, designation: "ABCD", password: self.passwordTxt.text!, confirm_password: self.confirmPasswordTxt.text!)
       
        let validationResult = SignupValidation().Validate(signupRequest: signupRequest)

        if !validationResult.success {
            self.showAlert(title: "", message: validationResult.error!)
            return
        }
        
        if !self.checkButton.isSelected {
            self.showAlert(title: "", message: "Please accept the Terms & Conditions")
            return
        }
        
        HPProgressHUD.show()
       
        OTPViewModel().generateOTP(otpRequest: OTPRequest(email: self.emailTxt.text!, mobileNo: mobile_no)) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if response?.status ?? false {
                print("\n\n\n NEW OTP is ", response?.data)
              //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    self.goToOTPView(request: signupRequest)
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
    // MARK: Go To OTP
    func goToOTPView(request:SignUpRequest){
        if let otpVC = OTPViewController.storyboardInstance(){
            otpVC.signUpRequest = request
            otpVC.isFromView = .SignUp
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
extension SignUpViewController:UITextFieldDelegate{
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
