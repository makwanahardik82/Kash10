//
//  SignupOTPViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 21/12/23.
//

import UIKit


class SignupOTPViewController: MainViewController {

    @IBOutlet weak var phoneOtpView: OTPFieldView!
    @IBOutlet weak var emailOtpView: OTPFieldView!
   
    @IBOutlet weak var phoneOtpTitleLabel: UILabel!
    @IBOutlet weak var emailOtpTitleLabel: UILabel!
   
    @IBOutlet weak var phoneOtpContainerView: UIView!
    
    @IBOutlet weak var resendOTPButton: UIButton!
    @IBOutlet weak var phoneTimerLabel: UILabel!
    @IBOutlet weak var emailTimerLabel: UILabel!
    

    var signUpRequest:SignUpRequest?
    var timer:Timer?
    var totalSecond = 61
    var otpRequest:OTPRequest?
    
    var completionBlock:((_ success: Bool) -> Void)?
    
    static func storyboardInstance() -> SignupOTPViewController? {
        return AppStoryboards.SignUp.instantiateViewController(identifier: "SignupOTPViewController") as? SignupOTPViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Create an Account")
  
        self.setupOtpView()
      
        self.phoneOtpTitleLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Enter the 6-digit OTP has been sent to ", font: AppFonts.Regular.size(size: 12), 5, .center).color(AppColors.blackThemeColor!, "\(self.signUpRequest?.mobile_number ?? "")", font: AppFonts.SemiBold.size(size: 12), 5, .center)
        
        self.emailOtpTitleLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Enter the 6-digit OTP has been sent to  ", font: AppFonts.Regular.size(size: 12), 5, .center).color(AppColors.blackThemeColor!, "\(self.otpRequest?.email ?? "")", font: AppFonts.SemiBold.size(size: 12), 5, .center)
        
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
        
     //   let color  = UIColor(named: "EA4C36")
        
        let str = "Resend code in \(self.totalSecond) sec"
       // let attr = NSMutableAttributedString().color(color, "Resend in ",font: //AppFonts.Regular.size(size: 12), 5, .center).color(.black, "", font: AppFonts.Medium.size(size: 12), 5, .center).color(color, " Sec", font: AppFonts.Regular.size(size: 12), 5, .center)
        // Resending in 1.29 sec
        self.phoneTimerLabel.text = str // attr
        self.emailTimerLabel.text = str //attr
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
        if phoneOtpString.count != 6 {
            self.showAlert(title: "", message: "Please enter OTP received on your phone.")
            return
        }
        if emailOtpString.count != 6 {
            self.showAlert(title: "", message: "Please enter OTP received on your email.")
            return
        }
        self.signUp(phoneOtp: phoneOtpString, emailOtp: emailOtpString)
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
        if let successVC = SignupSuccessViewController.storyboardInstance() {
            self.navigationController?.pushViewController(successVC, animated: true)
        }
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


extension SignupOTPViewController: OTPFieldViewDelegate {
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
