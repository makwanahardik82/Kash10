//
//  LicensePayNowViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 05/02/23.
//

import UIKit

class LicensePayNowViewController: MainViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet weak var licenseTableView: UITableView!
   
    @IBOutlet weak var serviceProviderLabel: PekoLabel!
    @IBOutlet weak var voucherNumberLabel: PekoLabel!
    @IBOutlet weak var voucherDateLabel: PekoLabel!
    @IBOutlet weak var voucherExpiryDateLabel: PekoLabel!
    @IBOutlet weak var amountLabel: PekoLabel!
    
    @IBOutlet weak var emiratesIdView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var customerNameView: PekoFloatingTextFieldView!
    
    static func storyboardInstance() -> LicensePayNowViewController? {
        return AppStoryboards.License.instantiateViewController(identifier: "LicensePayNowViewController") as? LicensePayNowViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "License Renewal")
        self.view.backgroundColor = .white
        self.licenseTableView.backgroundColor = .clear
        self.licenseTableView.tableHeaderView = self.headerView
        
        self.serviceProviderLabel.text = objLicenseRenewalManager?.limitDataModel?.serviceProvider ?? ""
        self.voucherNumberLabel.text = objLicenseRenewalManager?.balanceDataModel?.VoucherNumber ?? ""
      //  self.accountNumberLabel.text = objLicenseRenewalManager?.balanceDataModel?.AccountNumber
        
        self.voucherDateLabel.text = objLicenseRenewalManager?.balanceDataModel?.VocuherDate?.components(separatedBy: " ").first
        self.voucherExpiryDateLabel.text = objLicenseRenewalManager?.balanceDataModel?.VoucherExpiryDate?.components(separatedBy: " ").first
        
        self.amountLabel.text = objUserSession.currency + (objLicenseRenewalManager?.balanceDataModel?.Amount?.toDouble() ?? 0.0).decimalPoints()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Pay Now Button Click
    @IBAction func payNowButtonClick(_ sender: Any) {
      
        if(self.emiratesIdView.text!.isEmpty)
        {
            self.showAlert(title: "", message: "Please enter Emirates ID")
            return
        }
        if(self.customerNameView.text!.isEmpty)
        {
            self.showAlert(title: "", message: "Please enter Customer name")
            return
        }
       
        objLicenseRenewalManager?.customerName = self.customerNameView.text!
        objLicenseRenewalManager?.emiratesID = self.emiratesIdView.text!
        
        if let reviewPaymentVC = PaymentReviewViewController.storyboardInstance(){
            reviewPaymentVC.paymentPayNow = .License
            self.navigationController?.pushViewController(reviewPaymentVC, animated: true)
        }
        
    }
    
//    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

}
