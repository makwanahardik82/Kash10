//
//  CommonOTPViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 11/03/24.
//

import UIKit

class CommonOTPViewController: UIViewController {

    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var resendLabel: PekoLabel!
    
    @IBOutlet weak var otpView: OTPFieldView!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
 
    
    var timer:Timer?
    var totalSecond = 61
    
    var completionBlock:((_ success: String) -> Void)?
   
    static func storyboardInstance() -> CommonOTPViewController? {
        return AppStoryboards.Common.instantiateViewController(identifier: "CommonOTPViewController") as? CommonOTPViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLabel.attributedText = NSMutableAttributedString().color(.darkGray, "Enter the 6-digit OTP has been sent to ", font: .regular(size: 12), 3, .center).color(.black, objUserSession.profileDetail?.email ?? "", font: .bold(size: 12), 3, .center)
        
        self.setupOtpView()
        
        self.view.backgroundColor = AppColors.blackThemeColor?.withAlphaComponent(0.8)
     
        self.updateResendLabel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        self.animation()
    }
    
    // MARK: - ANIMATION
    func animation(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn, // curveEaseIn
                       animations: { () -> Void in
            
          //  self.superview?.layoutIfNeeded()
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            
        })
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
        self.resendLabel.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateResendLabel), userInfo: nil, repeats: true)
    }
    
    func invalidateTimer(){
        if timer != nil {
            timer?.invalidate()
        }
    }
    @objc func updateResendLabel()  {
        totalSecond = totalSecond - 1
        
        let str = "Resend code in \(self.totalSecond) sec"
        
        self.resendLabel.text = str //attr
        
        if totalSecond == 0 {
            self.invalidateTimer()
            self.resendOTPButton.isHidden = false
            self.resendLabel.isHidden = true
        }
    }
    
    // MARK: - Setup OTP View
    func setupOtpView(){
       
        self.otpView.backgroundColor = .clear
        self.otpView.fieldsCount = 6
        self.otpView.fieldBorderWidth = 1
        self.otpView.defaultBorderColor = UIColor.gray
        self.otpView.filledBorderColor = AppColors.borderThemeColor!
        self.otpView.cursorColor = UIColor.black
        self.otpView.displayType = .roundedCorner
        self.otpView.fieldSize = 40
        self.otpView.separatorSpace = 8
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.secureEntry = true
        self.otpView.initializeUI()
        self.otpView.fieldFont = AppFonts.ExtraBold.size(size: 40)
        
    }
    // MARK: - Resend
    @IBAction func resendButtonClick(_ sender: Any) {
        
    }
    
    // MARK: -
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    // MARK: - Verify
    @IBAction func verifyButtonClick(_ sender: Any) {
        
        let emailOtpString = self.otpView.getEnteredOTP()
       
        if emailOtpString.count != 6 {
            self.showAlert(title: "", message: "Please enter OTP received on your email.")
            return
        }
        if self.completionBlock != nil {
            self.completionBlock!(emailOtpString)
        }
        self.dismiss(animated: false)
        
    }
}
extension CommonOTPViewController: OTPFieldViewDelegate {
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
