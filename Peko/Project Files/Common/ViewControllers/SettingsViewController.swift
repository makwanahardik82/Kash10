//
//  SettingsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit
import SDWebImage

class SettingsViewController: MainViewController {

    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
  //  @IBOutlet weak var packageNameLabel: UILabel!
    
    @IBOutlet weak var settingTableView: UITableView!
    
    @IBOutlet weak var versionLabel: UILabel!
   
    @IBOutlet weak var firstLetterLabel: PekoLabel!
    @IBOutlet var headerView: UIView!
    
    let settingArray = [
        [
            "title":"TITLE_MANAGE_ACCOUNT",
            "image":"icon_account"
        ],
        [
            "title":"TITLE_HELP_DESK",
            "image":"icon_help_desk"
        ],
        [
            "title":"Notifications",
            "image":"icon_setting_notification"
        ],
        [
            "title":"TITLE_ABOUT",
            "image":"icon_about"
        ],
        [
            "title":"TITLE_LOGOUT",
            "image":"icon_logout"
        ]
    ]

    static func storyboardInstance() -> SettingsViewController? {
        return AppStoryboards.Settings.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        self.isNavigationTitle = true
//        self.setTitle(title: "TITLE_SETTINGS".localizeString())
//        
     //   self.navigationController!.isNavigationBarHidden = true
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        self.versionLabel.text = "TITLE_APP_VERSION".localizeString() + " " + "\(appVersion)v"
        
        let height = (screenWidth * 0.706)
        self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height + 20))
        view.addSubview(headerView)
        self.settingTableView.tableHeaderView = view
//        self.settingTableView.parallaxHeader.view = view
//        self.settingTableView.parallaxHeader.height = height + 20
//        self.settingTableView.parallaxHeader.mode = .center
//        
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.backgroundColor = .clear
        self.settingTableView.separatorStyle = .none
        
       // self.navigationController?.isNavigationBarHidden = true
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
//        DispatchQueue.main.async {
//            self.navigationController?.isNavigationBarHidden = false
//          }

        DispatchQueue.main.async {
          //  self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.navigationBar.isHidden = true

            self.nameLabel.text = objUserSession.profileDetail?.name
            self.firstLetterLabel.text = objUserSession.profileDetail?.name?.prefix(1).uppercased()
            
         //   self.packageNameLabel.text = objUserSession.pac
            
         //   self.logoImgView.sd_setImage(with: URL(string: (objUserSession.profileDetail?.logo ?? "")), placeholderImage: nil)
        }
        
        //DispatchQueue.main.async {
         //   self.navigationController?.isNavigationBarHidden = true
            
           // self.navigationController?.setNavigationBarHidden(true, animated: animated)
            
      //  }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.isNavigationBarHidden = true
        
        super.viewWillAppear(animated)
      
    }
    // MARK: - Edit Button Click
    @IBAction func editButtonClick(_ sender: Any) {
        if let profileVC = ProfileViewController.storyboardInstance() {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    // MARK: - Rate App
    @IBAction func rateAppButtonClick(_ sender: Any) {
        if let url = URL(string: Constants.AppRatingURL) {
            UIApplication.shared.open(url)
        }
    }
    
    
//    // MARK: - Set Statubar Style
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return objShareManager.appTarget == .PekoUAE ? .lightContent:.darkContent
//    }
    override var childForStatusBarStyle: UIViewController?{
        return self.navigationController?.topViewController
    }
}

extension SettingsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
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
        
        if (self.settingArray.count - 1) == indexPath.row {
            cell.titleLabel.textColorHex = "FF0000"
        }else{
            cell.titleLabel.textColorHex = "292D32"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        switch (indexPath.row + 1) {
        case 1: // Manage Account
            if let manageAccountVC = ManageAccountViewController.storyboardInstance() {
                self.navigationController?.pushViewController(manageAccountVC, animated: true)
            }
            break
        case 2: // Help
            if let helpVC = HelpViewController.storyboardInstance() {
                self.navigationController?.pushViewController(helpVC, animated: true)
            }
            break
            
        case 3: // Manage Beneficiary
            if let manageBeneficiaryVC = NotificationViewController.storyboardInstance() {
                self.navigationController?.pushViewController(manageBeneficiaryVC, animated: true)
            }
            break
        case 4: // about
            if let aboutVC = AboutViewController.storyboardInstance() {
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }
            break
        case 5:
            let actionSheet = UIAlertController(title: "TITLE_LOGOUT".localizeString(), message: "MSG_LOGOUT_FROM_APP".localizeString(), preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "TITLE_LOGOUT".localizeString(), style: .destructive,handler: { action in
               
                DispatchQueue.main.async {
                    objUserSession.logout()
                    objShareManager.navigateToViewController = .LoginVC
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeViewController"), object: nil)
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "TITLE_CANCEL".localizeString(), style: .cancel, handler: { action in
                
            }))
            
            self.present(actionSheet, animated: true)
            break
       
        default:
            
            break
        }
    }
}


class SettingTableViewCell:UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: PekoLabel!
    
}
