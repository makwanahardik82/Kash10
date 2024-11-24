//
//  CreatePasswordViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/01/23.
//

import UIKit


class CreatePasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTxt: PekoTextField!
    @IBOutlet weak var confirmPasswordTxt: PekoTextField!
  
    @IBOutlet weak var validationTableView: UITableView!
    
    var signupRequest:SignUpRequest?
    
    var validationTitleArray = [
        "Use minimum 8 characters",
        "1 uppercase letter",
        "1 lowercase letter",
        "Contain number",
        "Contain symbol",
    ]
    var validationValueArray = [
        false,
        false,
        false,
        false,
        false
    ]
    
    let red = UIColor(red: 224/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
    let green = UIColor(red: 5/255.0, green: 190/255.0, blue: 99/255.0, alpha: 1.0)
    
    static func storyboardInstance() -> CreatePasswordViewController? {
        return AppStoryboards.CreateAccount.instantiateViewController(identifier: "CreatePasswordViewController") as? CreatePasswordViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.isBackNavigationBarView = true
//        self.setTitle(title: "Create an Account")
//        
        self.passwordTxt.pekoTextFieldViewDelegate = self
        self.validationTableView.delegate = self
        self.validationTableView.dataSource = self
        self.validationTableView.backgroundColor = .clear
        self.validationTableView.separatorStyle = .none
    }
    
    // MARK: - Next Button Click
    @IBAction func nextButtnClick(_ sender: Any) {
        
        if(self.passwordTxt.text!.isEmpty)
        {
            let msg = "Please enter password"
            self.showAlert(title: "", message: msg)
            return
        }
        if(self.confirmPasswordTxt.text!.isEmpty)
        {
            let msg = "Please enter confirm password"
            self.showAlert(title: "", message: msg)
            return
        }
        
        if(self.passwordTxt.text != self.confirmPasswordTxt.text)
        {
           let msg = "Please password and confirm password doesn’t match"
            self.showAlert(title: "", message: msg)
            return
        }
        
        if self.validationValueArray.allSatisfy({$0}) {
            
        } else{
            let msg = "Please enter valid password"
             self.showAlert(title: "", message: msg)
             return
        }
        
        self.signupRequest?.password = self.passwordTxt.text!
        self.signupRequest?.confirm_password = self.confirmPasswordTxt.text!
        
        HPProgressHUD.show()
        
        OTPViewModel().generateOTP(otpRequest: OTPRequest(email: signupRequest?.email, mobileNo: signupRequest?.mobile_number)) {  response, error  in
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
                    self.goToOTPView()
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
    func goToOTPView(){
        if let successVC = CreateAccountOTPViewController.storyboardInstance() {
            successVC.signUpRequest = self.signupRequest
            self.navigationController?.pushViewController(successVC, animated: true)
        }
    }
    
    // VAlidation
    func getMissingValidation() {
        let str = self.passwordTxt.text!

        self.validationValueArray[0] = (str.count > 8)
        self.validationValueArray[1] = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: str)
        self.validationValueArray[2] = NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: str)
        self.validationValueArray[3] = NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: str)
        self.validationValueArray[4] = NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: str)
        
        self.validationTableView.reloadData()

    }
}

extension CreatePasswordViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.passwordTxt.text?.count == 0) {
            return 0
        }else{
            if section == 0 {
                return 1
            }else{
                return self.validationTitleArray.count
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ValidationCell")
        cell!.backgroundColor = .clear
        cell!.selectionStyle = .none
        
        let imgView = cell?.viewWithTag(101) as! UIImageView
        let titleLabel = cell?.viewWithTag(102) as! UILabel
        
        titleLabel.font = .light(size: 14)
        imgView.contentMode = .center
       
        if indexPath.section == 0 {
            
            if let count = self.validationValueArray.filter({$0}).count as? Int {
                if count >= 5 {
                    titleLabel.text = "Password Strenth: Strong"
                    titleLabel.textColor = green
                    imgView.image = UIImage(named: "icon_password_validation_tick")
                }else if count >= 3 {
                    titleLabel.text = "Password Strenth: Medium"
                    titleLabel.textColor = red
                    imgView.image = UIImage(named: "icon_password_validation_cross")
                }else{
                    titleLabel.text = "Password Strenth: Weak"
                    titleLabel.textColor = red
                    imgView.image = UIImage(named: "icon_password_validation_cross")
                }
            }
        }else{
            titleLabel.text = self.validationTitleArray[indexPath.row]
            
            if self.validationValueArray[indexPath.row]{
                imgView.image = UIImage(named: "icon_password_validation_tick")
                titleLabel.textColor = green
            }else{
                imgView.image = UIImage(named: "icon_password_validation_cross")
                titleLabel.textColor = red
            }
        }
        
        return cell!
    }
}
extension CreatePasswordViewController:PekoTextFieldDelegate {
    func textChange(textField: PekoTextField) {
        self.getMissingValidation()
        // self.validationLabel.attributedText = self.getMissingValidation(str: textField.text!)
    }
}
