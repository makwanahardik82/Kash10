//
//  PhoneBillDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 26/02/24.
//

import UIKit

class PhoneBillDetailViewController: MainViewController {

 //   @IBOutlet weak var mobileNumberLabel: PekoLabel!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var nameLabel: PekoLabel!
    @IBOutlet weak var numberLabel: PekoLabel!
    
    @IBOutlet weak var amountLabel: PekoLabel!
    
    
    @IBOutlet weak var serviceLabel: PekoLabel!
    @IBOutlet weak var mobileNumberLabel: PekoLabel!
    @IBOutlet weak var serviceProviderLabel: PekoLabel!
    
    static func storyboardInstance() -> PhoneBillDetailViewController? {
        return AppStoryboards.Phone_Bill.instantiateViewController(identifier: "PhoneBillDetailViewController") as? PhoneBillDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title:  "Bill Payments")
        self.view.backgroundColor = .white
       
        self.serviceProviderLabel.text = (objPhoneBillsManager!.limitDataModel?.serviceProvider ?? "")
        self.nameLabel.text = (objPhoneBillsManager?.phoneBillRequest?.holder_name ?? "")
        self.mobileNumberLabel.text = objPhoneBillsManager?.phoneBillRequest?.number
        self.numberLabel.text = objPhoneBillsManager?.phoneBillRequest?.number
        self.mobileNumberLabel.text = objPhoneBillsManager?.phoneBillRequest?.number
        
        if objPhoneBillsManager?.phoneBillType == .DU_Postpaid || objPhoneBillsManager?.phoneBillType == .Etisalat_Postpaid {
            self.serviceLabel.text = "Postpaid Recharge"
            self.amountLabel.text = objUserSession.currency + (objPhoneBillsManager?.balanceDataModel?.dueBalanceInAed ?? "")
           
        }else{
            self.serviceLabel.text = "Prepaid Recharge"
            self.amountLabel.text = objUserSession.currency + (objPhoneBillsManager?.phoneBillRequest?.amount ?? "")
           
        }
        
        if objPhoneBillsManager?.phoneBillType == .DU_Postpaid || objPhoneBillsManager?.phoneBillType == .DU_Prepaid {
            self.logoImgView.image = UIImage(named: "icon_phone_bill_du")
        }else{
            self.logoImgView.image = UIImage(named: "icon_phone_bill_etisalat")
        }
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Edit Button Click
    @IBAction func editButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Pay Now
    @IBAction func payNowButtonClick(_ sender: Any) {
        if let vc = PaymentReviewViewController.storyboardInstance() {
            vc.paymentPayNow = .PhoneBill
            self.navigationController?.pushViewController(vc, animated: true)
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

}
