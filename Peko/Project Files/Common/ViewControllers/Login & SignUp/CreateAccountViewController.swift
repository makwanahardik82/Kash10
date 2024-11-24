//
//  CreateAccountViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/02/24.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var verifyTitleLabel: UILabel!
    
    @IBOutlet weak var nameTxt: PekoTextField!
    @IBOutlet weak var companyNameTxt: PekoTextField!
    @IBOutlet weak var phoneNumberTxt: PekoTextField!
    @IBOutlet weak var emailTxt: PekoTextField!
   
    static func storyboardInstance() -> CreateAccountViewController? {
        return AppStoryboards.CreateAccount.instantiateViewController(identifier: "CreateAccountViewController") as? CreateAccountViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let color = UIColor(red: 81/255.0, green: 81/255.0, blue: 81/255.0, alpha: 1.0)
        self.verifyTitleLabel.attributedText = NSMutableAttributedString().color(color, "By clicking submit you verify that you are an authorised representative of this organisation and have the right to act on its behalf in the creation and management of this account. The organisation and you agree to the additional terms of Kash10. ".localizeString(), font: .regular(size: 8), 2, .left).underline(color, "Terms and conditions", font: .medium(size: 9))
        
    }
    
    
    // MARK: - Back Button
    
    @IBAction func loginButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Check Button
    @IBAction func checkButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    // MARK: - City Button Click
    @IBAction func cityButtonClick(_ sender: Any) {
//        let pickerVC = PickerListViewController.storyboardInstance()
//        pickerVC?.array = Constants.cityArray
//        pickerVC?.selectedString = self.cityView.text!
//        pickerVC?.titleString = "City"
//        pickerVC?.completionBlock = { string in
//            self.cityView.text = string
//        }
//        let nav = UINavigationController(rootViewController: pickerVC!)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true)
    }
    // MARK: - Sector Button Click
    @IBAction func companySizeButtonClick(_ sender: Any) {
//        let pickerVC = PickerListViewController.storyboardInstance()
//        pickerVC?.array = CommonConstants.companySizeArray
//        pickerVC?.selectedString = self.cityView.text!
//        pickerVC?.titleString = "Company Size"
//        pickerVC?.completionBlock = { string in
//            self.companySizeView.text = string
//        }
//        let nav = UINavigationController(rootViewController: pickerVC!)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true)
        
    }

    
    // MARK: - Register Button Click
    @IBAction func registerButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        
        let country_code = objUserSession.mobileCountryCode
        let country_Name = "US"
        
//        if objShareManager.getAppTarget() == .PekoUAE {
//            country_code = "971"
//            country_Name = "United Arab Emirates"
//        }else{
//            country_code = "91"
//            country_Name = "India"
//        }
        let mobile_no = self.phoneNumberTxt.text!
        
        let signupRequest = SignUpRequest(first_name: self.nameTxt.text!, last_name: "", mobile_number: mobile_no, company_name: "", city: "", sector: "", country_name: country_Name, country_code: country_code, email: self.emailTxt.text!, designation: "", password: self.companyNameTxt.text!, confirm_password: "")
        
        let validationResult = SignupValidation().Validate(signupRequest: signupRequest)
        
        if validationResult.success {
            self.sendOTP(signUpRequest: signupRequest)
//            if let createPass = CreatePasswordViewController.storyboardInstance() {
//                createPass.signupRequest = signupRequest
//                self.navigationController?.pushViewController(createPass, animated: true)
//            }
        }else{
            self.showAlert(title: "", message: validationResult.error!)
            return
        }
    }
    func sendOTP(signUpRequest:SignUpRequest){
        HPProgressHUD.show()
        
        OTPViewModel().generateOTP(otpRequest: OTPRequest(email: signUpRequest.email, mobileNo: signUpRequest.mobile_number,name: signUpRequest.first_name)) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if response?.status ?? false {
                //   print("\n\n\n NEW OTP is ", response?.data)
                //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    print("\n\n\n+++++++++++++++++++++++++++++++++++++++++")
                    print("\n EMAIL OTP ", response?.data?.emailOtp ?? "")
                    print("\n PHONE OTP ", response?.data?.phoneOtp ?? "")
                    print("\n\n\n+++++++++++++++++++++++++++++++++++++++++")
                    if let successVC = CreateAccountOTPViewController.storyboardInstance() {
                        successVC.signUpRequest = signUpRequest
                        self.navigationController?.pushViewController(successVC, animated: true)
                    }
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
