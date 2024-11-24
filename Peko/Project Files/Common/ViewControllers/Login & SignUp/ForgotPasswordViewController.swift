//
//  ForgotPasswordViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 21/12/23.
//

import UIKit


class ForgotPasswordViewController: MainViewController {

    @IBOutlet weak var userNameTxt: PekoTextField!
    @IBOutlet weak var resendTextLabel: PekoLabel!
    
    @IBOutlet weak var detailLabel: PekoLabel!
    
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var resendContainerView: UIView!
    
   // @IBOutlet weak var userNameView: PekoFloatingTextFieldView!
    static func storyboardInstance() -> ForgotPasswordViewController? {
        return AppStoryboards.ForgotPassword.instantiateViewController(identifier: "ForgotPasswordViewController") as? ForgotPasswordViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Reset Password")
        
        detailLabel.attributedText = NSMutableAttributedString().color(.black, "A verification link has been sent to your email address. Please click on the link to reset your password.", font: .light(size: 10), 5, .center)
        
        
        self.resendTextLabel.attributedText = NSMutableAttributedString().color(.black, "It may take a few minutes for the email to arrive (check your spam folder). \nDidn’t get it? ", font: .light(size: 8), 5, .center).color(.black, "Resend Email.", font: .regular(size: 10), 5, .center)
        
        self.textContainerView.isHidden = false
        self.resendContainerView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Continue Button Click
    @IBAction func continueButtonClick(_ sender: Any) {
  
        self.view.endEditing(true)

        if self.userNameTxt.text?.count == 0 {
            self.showAlert(title: "", message: "Please enter username / email")
            return
        }else{
            
            HPProgressHUD.show()
            ForgotPasswordViewModel().forgotPassword(username: self.userNameTxt.text!) { response, error  in
                
                HPProgressHUD.hide()
                
                if error != nil {
                    #if DEBUG
                    self.showAlert(title: "", message: error?.localizedDescription ?? "")
    #else
                    self.showAlert(title: "", message: "Something went wrong please try again")
    #endif

                }else if response?.status ?? false {
                    print("\n\n\n Forgot Password ", response?.message)
                  //  signupRequest.otp = response?.data!
                    DispatchQueue.main.async {
                        self.textContainerView.isHidden = true
                        self.resendContainerView.isHidden = false//                        self.showAlertWithCompletion(title: "", message: response?.message ?? "") { action in
//                            self.navigationController?.popViewController(animated: false)
//                        }
                    }
                }else{
                    var msg = ""
                    if response?.message != nil {
                        msg = response?.message ?? ""
                    }else if response?.error != nil {
                        msg = response?.error ?? ""
                    }
                    self.showAlert(title: "", message: msg)
                }
            }
            
        }
    }
  
    // MARK: - Resend
    @IBAction func resendButtonClick(_ sender: Any) {
        self.textContainerView.isHidden = false
        self.resendContainerView.isHidden = true
       
        
    }
    
}
