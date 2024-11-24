//
//  CreateAccountOTPViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/02/24.
//

import UIKit


class CreateAccountOTPViewController: UIViewController {

  //  @IBOutlet weak var phoneOtpView: OTPFieldView!
    @IBOutlet weak var emailOtpView: OTPFieldView!
   
  //  @IBOutlet weak var phoneOtpTitleLabel: UILabel!
    @IBOutlet weak var emailOtpTitleLabel: UILabel!
   
   // @IBOutlet weak var phoneOtpContainerView: UIView!
    
    @IBOutlet weak var resendOTPButton: UIButton!
  //  @IBOutlet weak var phoneTimerLabel: UILabel!
    @IBOutlet weak var emailTimerLabel: UILabel!
    
    var signUpRequest:SignUpRequest?
    var timer:Timer?
    var totalSecond = 61
    var otpRequest:OTPRequest?
    
    var completionBlock:((_ success: Bool) -> Void)?
    
    static func storyboardInstance() -> CreateAccountOTPViewController? {
        return AppStoryboards.CreateAccount.instantiateViewController(identifier: "CreateAccountOTPViewController") as? CreateAccountOTPViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        self.isBackNavigationBarView = true
//        self.setTitle(title: "Create an Account")
  
        self.setupOtpView()
        self.otpRequest = OTPRequest(email: self.signUpRequest?.email!, mobileNo: self.signUpRequest?.mobile_number!)
    
        
        let str = "Enter the 6-digit OTP has been sent to " + objUserSession.mobileCountryCode + "\(self.otpRequest?.mobileNo ?? "")"
        
        let color = UIColor(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0)
        self.emailOtpTitleLabel.attributedText = NSMutableAttributedString().color(color, str, font: .regular(size: 13), 5, .left)
       
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
    
    // MARK: - Go Bakc
    @IBAction func goBackButton(_ sender: Any) {
        let vc = self.navigationController?.viewControllers[2]
     //   print(vc)
        self.navigationController?.popToViewController(vc!, animated: false)
       // self.navigationController?.popToViewController(vc[1] as! UIViewController, animated: false)
    }
    
    
    func startTimer(){
        
        self.resendOTPButton.isHidden = true
        self.emailTimerLabel.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateResendLabel), userInfo: nil, repeats: true)
    }
    
    func invalidateTimer(){
        if timer != nil {
            timer?.invalidate()
        }
    }
    @objc func updateResendLabel()  {
        totalSecond = totalSecond - 1
        
        let str = "Resend OTP in \(self.totalSecond) sec"
        
        self.emailTimerLabel.text = str //attr
        
        if totalSecond == 0 {
            self.invalidateTimer()
            self.resendOTPButton.isHidden = false
            self.emailTimerLabel.isHidden = true
        }
    }
    
    // MARK: - Setup OTP View
    func setupOtpView(){
       
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
       
        let emailOtpString = self.emailOtpView.getEnteredOTP()
       
        if emailOtpString.count != 6 {
            self.showAlert(title: "", message: "Please enter OTP received on your email.")
            return
        }
        self.signUp(phoneOtp: emailOtpString, emailOtp: emailOtpString)
        
    }
    
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
        if let successVC = CreateAccountSuccessViewController.storyboardInstance() {
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
extension CreateAccountOTPViewController: OTPFieldViewDelegate {
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
