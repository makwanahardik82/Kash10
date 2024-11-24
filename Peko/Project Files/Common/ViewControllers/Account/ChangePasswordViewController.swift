//
//  ChangePasswordViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/01/23.
//

import UIKit

class ChangePasswordViewController: MainViewController {
    
    @IBOutlet weak var oldPassowrdView: PekoFloatingTextFieldView!
    @IBOutlet weak var newPasswordView: PekoFloatingTextFieldView!
    @IBOutlet weak var confirmPasswordView: PekoFloatingTextFieldView!
  
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
    
    @IBOutlet weak var validationTableView: UITableView!
 
    static func storyboardInstance() -> ChangePasswordViewController? {
        return AppStoryboards.Account.instantiateViewController(identifier: "ChangePasswordViewController") as? ChangePasswordViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Change Password")
        self.view.backgroundColor = .white
        
        
        self.newPasswordView.delegate = self
        self.validationTableView.delegate = self
        self.validationTableView.dataSource = self
        self.validationTableView.backgroundColor = .clear
        self.validationTableView.separatorStyle = .none
        
    }
    
    // MARK: - Submit Button Click
    @IBAction func submitButtonClick(_ sender: Any) {
        self.view.endEditing(true)

        let passwordRequest = ChangePasswordRequest(oldPassword: self.oldPassowrdView.text!, newPassword: self.newPasswordView.text!, confirmPassword: self.confirmPasswordView.text!)
     
        let validationResult = ChangePasswordValidation().Validate(changePasswordRequest: passwordRequest)

        if validationResult.success {
            
            if self.validationValueArray.allSatisfy({$0}) {
                HPProgressHUD.show()
                ChangePasswordViewModel().changePassowrd(changePasswordRequest: passwordRequest) { response in
                    
                    HPProgressHUD.hide()
                    
                    if let status = response?.status, status == true {
                        DispatchQueue.main.async {
                            self.showAlertWithCompletion(title: "", message: response?.message ?? "") { action in
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        self.showAlert(title: "", message: response?.message ?? "")
                    }
                }
            } else{
                let msg = "Please enter valid password"
                 self.showAlert(title: "", message: msg)
                 return
            }
            
            
      
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }

    // VAlidation
    func getMissingValidation() {
        let str = self.newPasswordView.text!

        self.validationValueArray[0] = (str.count > 8)
        self.validationValueArray[1] = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: str)
        self.validationValueArray[2] = NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: str)
        self.validationValueArray[3] = NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: str)
        self.validationValueArray[4] = NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: str)
        
        self.validationTableView.reloadData()

    }
}

extension ChangePasswordViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.newPasswordView.text?.count == 0) {
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
extension ChangePasswordViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        self.getMissingValidation()
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        
    }
    
}
