//
//  SignUpViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/12/23.
//

import UIKit


class SignUpViewController: UIViewController {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var verifyTitleLabel: UILabel!
    
    @IBOutlet weak var firstNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var lastNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var phoneNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var designationView: PekoFloatingTextFieldView!
    @IBOutlet weak var emailView: PekoFloatingTextFieldView!
    @IBOutlet weak var passwordView: PekoFloatingTextFieldView!
    @IBOutlet weak var confirmPasswordView: PekoFloatingTextFieldView!
    
    
    @IBOutlet weak var companyNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var cityView: PekoFloatingTextFieldView!
    @IBOutlet weak var companySizeView: PekoFloatingTextFieldView!
    @IBOutlet weak var gstNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var panNumberView: PekoFloatingTextFieldView!
    
    
    static func storyboardInstance() -> SignUpViewController? {
        return AppStoryboards.SignUp.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.verifyTitleLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "TITLE_VERIFY_ACCOUNT_TEXT".localizeString(), font: AppFonts.Regular.size(size: 12), 5, .left)
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
        let pickerVC = PickerListViewController.storyboardInstance()
        pickerVC?.array = Constants.cityArray
        pickerVC?.selectedString = self.cityView.text!
        pickerVC?.titleString = "City"
        pickerVC?.completionBlock = { string in
            self.cityView.text = string
        }
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    // MARK: - Sector Button Click
    @IBAction func companySizeButtonClick(_ sender: Any) {
        let pickerVC = PickerListViewController.storyboardInstance()
        pickerVC?.array = CommonConstants.companySizeArray
        pickerVC?.selectedString = self.cityView.text!
        pickerVC?.titleString = "Company Size"
        pickerVC?.completionBlock = { string in
            self.companySizeView.text = string
        }
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        
    }

    
    // MARK: - Register Button Click
    @IBAction func registerButtonClick(_ sender: Any) {
       
        self.view.endEditing(true)
        let mobile_no = "+91" + self.phoneNumberView.text!
        let country_code = "91"
        
        let signupRequest = SignUpRequest(first_name: self.firstNameView.text!, last_name: self.lastNameView.text!, mobile_number: mobile_no, company_name: self.companyNameView.text!, city: self.cityView.text!, sector: self.companySizeView.text!, country_name: "India", country_code: country_code, email: self.emailView.text!, designation: self.designationView.text!, password: self.passwordView.text!, confirm_password: self.confirmPasswordView.text!)
       
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
       
        OTPViewModel().generateOTP(otpRequest: OTPRequest(email: self.emailView.text!, mobileNo: mobile_no)) {  response, error  in
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
       
        if let otpView = SignupOTPViewController.storyboardInstance() {
            otpView.signUpRequest = request
            self.navigationController?.pushViewController(otpView, animated: true)
        }
    }
}
