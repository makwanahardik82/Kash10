//
//  ManageAccountViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 07/01/23.
//

import UIKit

class ManageAccountViewController: MainViewController {

    @IBOutlet weak var accountTableView: UITableView!
    static func storyboardInstance() -> ManageAccountViewController? {
        return AppStoryboards.Account.instantiateViewController(identifier: "ManageAccountViewController") as? ManageAccountViewController
    }
    
    let settingArray = [
        [
            "title":"Account Settings",
            "image":"icon_account_settings"
        ],
//        [
//            "title":"Saved Addresses",
//            "image":"icon_account_address"
//        ],
//        [
//            "title":"Saved Bank Accounts",
//            "image":"icon_account_bank_account"
//        ],
        [
            "title":"Change Password",
            "image":"icon_account_change_password"
        ]
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Manage Account")
        self.view.backgroundColor = .white
        
        self.accountTableView.backgroundColor = .clear
        self.accountTableView.separatorStyle = .none
        self.accountTableView.delegate = self
        self.accountTableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        
        
        
        
    }
}
extension ManageAccountViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let dic = settingArray[indexPath.row]
        cell.titleLabel.font = .regular(size: 11)
        cell.titleLabel.textKey = dic["title"]
        cell.imgView.image = UIImage(named: dic["image"]!)
        cell.titleLabel.textColorHex = "292D32"
  
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // Account Setting
            if let aboutVC = AccountSettingsViewController.storyboardInstance() {
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }
            break
            /*
        case 1: // Saved Addresses
            if let addressVC = SavedAddressViewController.storyboardInstance() {
                self.navigationController?.pushViewController(addressVC, animated: true)
            }
            break
        case 2: // Saved Bank Account
            if let bankVC = SavedBankViewController.storyboardInstance() {
                self.navigationController?.pushViewController(bankVC, animated: true)
            }
            break
            */
        case 1: // Change Password
            if let changePWVC = ChangePasswordViewController.storyboardInstance(){
                self.navigationController?.pushViewController(changePWVC, animated: true)
            }
            break
        case 2: // Secuirty
            if let securityVC = SecurityViewController.storyboardInstance(){
                self.navigationController?.pushViewController(securityVC, animated: true)
            }
            break
        case 3: // Delete Account
            if let deleteVC = DeleteAccountViewController.storyboardInstance(){
                self.navigationController?.pushViewController(deleteVC, animated: true)
            }
            break
        default:
            
            break
        }
    }
}
