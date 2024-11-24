//
//  UtilityBillDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 27/02/24.
//

import UIKit

class UtilityBillDetailViewController: MainViewController {

   // @IBOutlet weak var mobileNumberLabel: PekoLabel!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var nameLabel: PekoLabel!
    @IBOutlet weak var numberLabel: PekoLabel!
    
    @IBOutlet weak var amountLabel: PekoLabel!
    
    
    @IBOutlet weak var serviceLabel: PekoLabel!
    @IBOutlet weak var mobileNumberLabel: PekoLabel!
    @IBOutlet weak var serviceProviderLabel: PekoLabel!
    
    
    static func storyboardInstance() -> UtilityBillDetailViewController? {
        return AppStoryboards.Utility.instantiateViewController(identifier: "UtilityBillDetailViewController") as? UtilityBillDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title:  "Bill Payments")
        self.view.backgroundColor = .white
       
        self.nameLabel.text = (objUtilityPaymentManager?.utilityPaymentRequest?.holder_name ?? "")
        self.mobileNumberLabel.text = objUtilityPaymentManager?.utilityPaymentRequest?.acoountNumber
        self.numberLabel.text = objUtilityPaymentManager?.utilityPaymentRequest?.acoountNumber
        self.mobileNumberLabel.text = objUtilityPaymentManager?.utilityPaymentRequest?.acoountNumber
     
        if objUtilityPaymentManager?.utilityPaymentType == .Salik || objUtilityPaymentManager?.utilityPaymentType == .Nol_Card{
            self.amountLabel.text = objUserSession.currency + (objUtilityPaymentManager?.utilityPaymentRequest?.amount ?? "0").toDouble().withCommas()
        }else{
            self.amountLabel.text = objUserSession.currency +  (objUtilityPaymentManager?.balanceDataModel?.dueBalanceInAed ?? "0").toDouble().withCommas()
        }
       
        self.serviceLabel.text = "Utility Bills"
        let dic = Constants.utilityPaymentArray[objUtilityPaymentManager?.utilityPaymentType?.rawValue ?? 0]
        
        self.logoImgView.image = UIImage(named: dic["icon"]!)
        self.serviceProviderLabel.text = dic["title"]! 
        
        //(objPhoneBillsManager!.limitDataModel?.serviceProvider ?? "")
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Edit Button Click
    @IBAction func editButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Pay Now
    @IBAction func payNowButtonClick(_ sender: Any) {
        if let vc = PaymentReviewViewController.storyboardInstance() {
            vc.paymentPayNow = .UtilityBill
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
