//
//  OTPViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit


enum IsFrom: Int {
    case SignUp = 0
   // case ForgotPassword
   // case SubscriptionPayment
    case AddPhoneBillBeneficiary
    case UpdatePhoneBillBeneficiary
    
    case AddUtilityBeneficiary
    case UpdateUtilityBeneficiary
}


class OTPViewController: MainViewController {

    @IBOutlet weak var phoneOtpView: OTPFieldView!
    @IBOutlet weak var emailOtpView: OTPFieldView!
   
    @IBOutlet weak var phoneOtpTitleLabel: UILabel!
    @IBOutlet weak var emailOtpTitleLabel: UILabel!
   
    @IBOutlet weak var phoneOtpContainerView: UIView!
    
    @IBOutlet weak var resendOTPButton: UIButton!
    @IBOutlet weak var phoneTimerLabel: UILabel!
    @IBOutlet weak var emailTimerLabel: UILabel!
    
 //   var hasEnteredOTP = false
   // var otpString = ""
    
  //  var isResendOTP = false
    
    var isFromView:IsFrom = .SignUp
    
    var signUpRequest:SignUpRequest?
    var timer:Timer?
    var totalSecond = 61
    var otpRequest:OTPRequest?
    
    var completionBlock:((_ success: Bool) -> Void)?
    
    static func storyboardInstance() -> OTPViewController? {
        return AppStoryboards.SignUp.instantiateViewController(identifier: "OTPViewController") as? OTPViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        if self.isFromView == .SignUp {
            self.setTitle(title: "Create an account")
            self.otpRequest = OTPRequest(email: self.signUpRequest?.email!, mobileNo: self.signUpRequest?.mobile_number!)
            
        }
        
        self.setupOtpView()
      
        self.phoneOtpTitleLabel.text = "OTP has been sent on your phone number "
        self.emailOtpTitleLabel.text = "Your OTP has sent to \(self.otpRequest?.email ?? "")"
        
        self.updateResendLabel()
        //self.errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        self.startTimer()
        self.navigationController?.isNavigationBarHidden = true
    }
   // MARK: -
    override func viewWillDisappear(_ animated: Bool) {
        self.invalidateTimer()
    }
    
    func startTimer(){
        
        self.resendOTPButton.isHidden = true
        self.emailTimerLabel.isHidden = false
        self.phoneTimerLabel.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateResendLabel), userInfo: nil, repeats: true)
    }
    
    func invalidateTimer(){
        if timer != nil {
            timer?.invalidate()
        }
    }
    @objc func updateResendLabel()  {
        totalSecond = totalSecond - 1
        let attr = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Resend in ",font: AppFonts.Regular.size(size: 12), 5, .center).color(.black, "\(self.totalSecond)", font: AppFonts.Medium.size(size: 12), 5, .center).color(.black, " Sec", font: AppFonts.Regular.size(size: 12), 5, .center)
        // Resending in 1.29 sec
        self.phoneTimerLabel.attributedText = attr
        self.emailTimerLabel.attributedText = attr
    //    self.smsResendLabel.attributedText = attr
        
        if totalSecond == 0 {
            self.invalidateTimer()
            self.resendOTPButton.isHidden = false
            self.phoneTimerLabel.isHidden = true
            self.emailTimerLabel.isHidden = true
            
        }
    }
    
    // MARK: - Setup OTP View
    func setupOtpView(){
        self.phoneOtpView.backgroundColor = .clear
        self.phoneOtpView.fieldsCount = 6
        self.phoneOtpView.fieldBorderWidth = 1
        self.phoneOtpView.defaultBorderColor = UIColor.gray
        self.phoneOtpView.filledBorderColor = AppColors.borderThemeColor!
        self.phoneOtpView.cursorColor = UIColor.black
        self.phoneOtpView.displayType = .roundedCorner
        self.phoneOtpView.fieldSize = 45
        self.phoneOtpView.separatorSpace = 8
        self.phoneOtpView.shouldAllowIntermediateEditing = false
        self.phoneOtpView.delegate = self
        self.phoneOtpView.secureEntry = true
        self.phoneOtpView.initializeUI()
        self.phoneOtpView.fieldFont = AppFonts.ExtraBold.size(size: 40)
        
        self.emailOtpView.backgroundColor = .clear
        self.emailOtpView.fieldsCount = 6
        self.emailOtpView.fieldBorderWidth = 1
        self.emailOtpView.defaultBorderColor = UIColor.gray
        self.emailOtpView.filledBorderColor = AppColors.borderThemeColor!
        self.emailOtpView.cursorColor = UIColor.black
        self.emailOtpView.displayType = .roundedCorner
        self.emailOtpView.fieldSize = 45
        self.emailOtpView.separatorSpace = 8
        self.emailOtpView.shouldAllowIntermediateEditing = false
        self.emailOtpView.delegate = self
        self.emailOtpView.secureEntry = true
        self.emailOtpView.initializeUI()
        self.emailOtpView.fieldFont = AppFonts.ExtraBold.size(size: 40)
        
    }
    // MARK: - Submit
    @IBAction func submitButtonClick(_ sender: Any) {
        
        let phoneOtpString = self.phoneOtpView.getEnteredOTP()
        let emailOtpString = self.emailOtpView.getEnteredOTP()
        
        
        if self.isFromView == .SignUp {
            if phoneOtpString.count != 6 {
                self.showAlert(title: "", message: "Please enter OTP received on your phone.")
                return
            }
            if emailOtpString.count != 6 {
                self.showAlert(title: "", message: "Please enter OTP received on your email.")
                return
            }
            self.signUp(phoneOtp: phoneOtpString, emailOtp: emailOtpString)
        }else{
            if emailOtpString.count != 6 {
                self.showAlert(title: "", message: "Please enter OTP received on your email.")
                return
            }
            
            if completionBlock != nil {
             //   self.completionBlock!(emailOtpString)
            }
            self.navigationController?.popViewController(animated: false)
        }
    }
    // MARK SIgn Up
    func signUp(phoneOtp:String, emailOtp:String) {
       // self.signUpRequest?.otp = self.otpString
        HPProgressHUD.show()
        SignupViewModel().userSignup(signupRequest: self.signUpRequest!, phoneOtp: phoneOtp, emailOtp: emailOtp) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if response?.status ?? false {
                DispatchQueue.main.async {
                    self.successView()
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
    
    // MARK: - Success Screen
    func successView(){
//        if let successVC = SuccessSignupViewController.storyboardInstance() {
//            self.navigationController?.pushViewController(successVC, animated: true)
//        }
    }
    // MARK: - ReSend OTP
    @IBAction func resendButtonClick(_ sender: Any) {
        
        HPProgressHUD.show()
        OTPViewModel().generateOTP(otpRequest: self.otpRequest!) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if response?.status ?? false {
              //  print("\n\n\n NEW OTP is ", response?.data)
              //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "OTP sent!")
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
extension OTPViewController: OTPFieldViewDelegate {
    func enteredOTP(otp otpString: String) {
     //   self.otpString = otpString
     //   self.verifyPinRequest(str:otpString)
        print("OTPString: \(otpString)")
      
    }
    
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
    //    hasEnteredOTP = hasEntered
       // self.errorLabel.isHidden = true
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
}
