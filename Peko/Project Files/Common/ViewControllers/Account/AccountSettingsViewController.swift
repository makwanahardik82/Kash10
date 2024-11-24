//
//  AccountSettingsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 25/03/24.
//

import UIKit

class AccountSettingsViewController: MainViewController {

    @IBOutlet weak var accountTableView: UITableView!
   
    static func storyboardInstance() -> AccountSettingsViewController? {
        return AppStoryboards.Account.instantiateViewController(identifier: "AccountSettingsViewController") as? AccountSettingsViewController
    }
    
    let settingArray = [
        [
            "title":"Security",
            "image":"icon_account_security"
        ],
        [
            "title":"Delete Account",
            "image":"icon_account_delete"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "AccountSettings")
        self.view.backgroundColor = .white
        
        self.accountTableView.backgroundColor = .clear
        self.accountTableView.separatorStyle = .none
        self.accountTableView.delegate = self
        self.accountTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}
extension AccountSettingsViewController:UITableViewDelegate, UITableViewDataSource{
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
      
        case 0: // Secuirty
            if let securityVC = SecurityViewController.storyboardInstance(){
                self.navigationController?.pushViewController(securityVC, animated: true)
            }
            break
        case 1: // Delete Account
            if let deleteVC = DeleteAccountViewController.storyboardInstance(){
                self.navigationController?.pushViewController(deleteVC, animated: true)
            }
            break
        default:
            
            break
        }
    }
}
