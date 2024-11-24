//
//  SecurityViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/02/24.
//

import UIKit

class SecurityViewController: MainViewController {

    @IBOutlet weak var securitytableView: UITableView!
   
    var titleArray = ["SMS", "Email", "Authenticator App"]
    
    var sendMfaCodeToAuthApp = false
    var sendMfaCodeToEmail = false
    var sendMfaCodeToPhone = false
    
    static func storyboardInstance() -> SecurityViewController? {
        return AppStoryboards.Account.instantiateViewController(identifier: "SecurityViewController") as? SecurityViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Security")
        self.view.backgroundColor = .white
        
        self.securitytableView.delegate = self
        self.securitytableView.dataSource = self
        self.securitytableView.separatorStyle = .none
        self.securitytableView.backgroundColor = .clear
        
        sendMfaCodeToAuthApp = (objUserSession.profileDetail?.sendMfaCodeToAuthApp ?? 0).boolValue
        sendMfaCodeToEmail = (objUserSession.profileDetail?.sendMfaCodeToEmail ?? 0).boolValue
        sendMfaCodeToPhone = (objUserSession.profileDetail?.sendMfaCodeToPhone ?? 0).boolValue
        
    }
    // MARK: - Update MFA
    func updateMFASeetings(){
        HPProgressHUD.show()
        let param = [
            "isMFA": 0,
            "sendMfaCodeToAuthApp": self.sendMfaCodeToAuthApp,
            "sendMfaCodeToEmail": self.sendMfaCodeToEmail,
            "sendMfaCodeToPhone": self.sendMfaCodeToPhone
        ] as [String : Any]
        ProfileViewModel().updateMFASettings(param: param){ response, error in
            HPProgressHUD.hide()
            print(response)
            if let status = response.status, status == true {
                DispatchQueue.main.async {
                    if let message = response.message {
                        self.showAlert(title: "", message: message)
                    }
                    
                   
                    
                    self.securitytableView.reloadData()
                }
            }else{
                HPProgressHUD.hide()
                var msg = ""
                if response.message != nil {
                    msg = response.message ?? ""
                }else if response.error?.count != nil {
                    msg = response.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    
}
// MARK: -
extension SecurityViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecurityTableViewCell")  as! SecurityTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.titleLabel.font = .regular(size: 11)
        cell.titleLabel.textKey = self.titleArray[indexPath.row]
        cell.titleLabel.textColorHex = "292D32"
        
        cell.switchControl.addTarget(self, action: #selector(switchButtonClick(sender: )), for: .valueChanged)
        cell.switchControl.tag = indexPath.row
        
        if indexPath.row == 0 {
            cell.switchControl.isOn = self.sendMfaCodeToPhone
        }else if indexPath.row == 1 {
            cell.switchControl.isOn = self.sendMfaCodeToEmail
        }else if indexPath.row == 2 {
            cell.switchControl.isOn = self.sendMfaCodeToAuthApp
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Switch Button Click
    @objc func switchButtonClick(sender:UISwitch) {
        
        if sender.tag == 0 {
            self.sendMfaCodeToPhone = sender.isOn
        }else if sender.tag == 1 {
            self.sendMfaCodeToEmail = sender.isOn
        }else if sender.tag == 2 {
            self.sendMfaCodeToAuthApp = sender.isOn
        }
        self.updateMFASeetings()
        
    }
    
}
// MARK: - SecurityTableViewCell
class SecurityTableViewCell:UITableViewCell {
    
    @IBOutlet weak var titleLabel: PekoLabel!
    
    @IBOutlet weak var switchControl: UISwitch!
   // @IBOutlet weak var switchButton: UIButton!
    
}


