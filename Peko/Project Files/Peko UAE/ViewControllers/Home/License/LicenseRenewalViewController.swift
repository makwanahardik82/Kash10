//
//  LicenseRenewalViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 02/02/23.
//

import UIKit


class LicenseRenewalViewController: MainViewController {

    @IBOutlet weak var label_1: UILabel!
    @IBOutlet weak var label_2: UILabel!
    
    @IBOutlet weak var voucherIdView: PekoFloatingTextFieldView!
    // @IBOutlet weak var voucherIdTxt: UITextField!
    
    static func storyboardInstance() -> LicenseRenewalViewController? {
        return AppStoryboards.License.instantiateViewController(identifier: "LicenseRenewalViewController") as? LicenseRenewalViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "License Renewal")
        self.view.backgroundColor = .white
        
        self.label_1.attributedText = NSMutableAttributedString().color(.black, "To renew your license, Please send your ", font: AppFonts.Regular.size(size: 14), 8, .left).color(.black, "License number", font: AppFonts.Bold.size(size: 14), 8, .left).color(.black, " via ", font: AppFonts.Regular.size(size: 14), 8, .left).color(.black, "SMS to 6969", font: AppFonts.Bold.size(size: 14), 8, .left)
     
        self.label_2.attributedText = NSMutableAttributedString().color(.black, "Enter ", font: AppFonts.Regular.size(size: 14), 8, .left).color(.black, "Voucher ID", font: AppFonts.Bold.size(size: 14), 8, .center).color(.black, " from the SMS you received", font: AppFonts.Regular.size(size: 14), 8, .left)
          
      //  Enter Voucher ID from the SMS you received
        
        self.getLimitData()
          
        // Do any additional setup after loading the view.
    }
    func getLimitData(){
        objLicenseRenewalManager = LicenseRenewalManager.sharedInstance
        
        HPProgressHUD.show()
        LicenseRenewalViewModel().getLimitData() { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    objLicenseRenewalManager?.limitDataModel = response?.data!
                    
//                    if let payVC = LicensePayNowViewController.storyboardInstance() {
//
//                        self.navigationController?.pushViewController(payVC, animated: true)
//                    }
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
    // MARK: - Search Button Click
    @IBAction func searchButtonClick(_ sender: Any) {
        
        if self.voucherIdView.text?.count == 0 {
            self.showAlert(title: "", message: "Please enter voucher ID")
            return
        }
       
        HPProgressHUD.show()
        LicenseRenewalViewModel().getBalanceData(number: self.voucherIdView.text!) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    objLicenseRenewalManager?.balanceDataModel = response?.data!
                    
                    if let payNowVC = LicensePayNowViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(payNowVC, animated: true)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
