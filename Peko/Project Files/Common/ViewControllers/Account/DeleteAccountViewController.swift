//
//  DeleteAccountViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 07/01/23.
//

import UIKit

class DeleteAccountViewController: MainViewController {

    static func storyboardInstance() -> DeleteAccountViewController? {
        return AppStoryboards.Account.instantiateViewController(identifier: "DeleteAccountViewController") as? DeleteAccountViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Delete your account")
        
    }
    // MARK: - Yes Button
    @IBAction func yesButtonClick(_ sender: Any) {
        
        HPProgressHUD.show()
        WSManager.postRequest(url: ApiEnd().DELETE_ACCOUNT, param: [:], resultType: ResponseModel<[String:String]>.self) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.showAlertWithCompletion(title: "", message: response?.message ?? "") { action in
                        objShareManager.navigateToViewController = .LoginVC
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeViewController"), object: nil)
                    }
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
    // MARK: - Cancel Button
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
}
