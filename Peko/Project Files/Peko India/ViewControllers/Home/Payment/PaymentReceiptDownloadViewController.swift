//
//  PaymentReceiptViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 13/12/23.
//

import UIKit

class PaymentReceiptDownloadViewController: MainViewController {

    @IBOutlet weak var supportLabel: UILabel!
    
    @IBOutlet weak var paymentAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var txnIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
   
    @IBOutlet weak var consumerNumberLabel: UILabel!
    @IBOutlet weak var serviceOperatorLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var voucherLabel: UILabel!
    
    @IBOutlet weak var serviceTitleLabel: PekoLabel!
    
    @IBOutlet weak var bharatBillAssuredImgView: UIImageView!
    
    //\ @IBOutlet weak var serviceTitleLabel: UILabel!
    
    static func storyboardInstance() -> PaymentReceiptDownloadViewController? {
        return AppStoryboards.Payment.instantiateViewController(identifier: "PaymentReceiptDownloadViewController") as? PaymentReceiptDownloadViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: objPaymentManager!.screenTitle)
        
        self.supportLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "For any queries or support, please contact us at ", font: AppFonts.Regular.size(size: 12), 5, .center).color(AppColors.blackThemeColor!, "support@peko.one", font: AppFonts.SemiBold.size(size: 12), 5, .center)
       
        
        self.txnIdLabel.text = objPaymentManager?.transactionID
        self.dateLabel.text = objPaymentManager?.dateString
        self.timeLabel.text = objPaymentManager?.timeString
        
        self.serviceLabel.text = objPaymentManager?.service
        self.consumerNumberLabel.text = objPaymentManager?.consumerNumber
        self.serviceOperatorLabel.text = objPaymentManager?.serviceProvider
        
        self.priceLabel.text = objUserSession.currency + (objPaymentManager?.price.withCommas())!
        self.voucherLabel.text = objUserSession.currency + (objPaymentManager?.voucher.withCommas())!
     
        self.totalAmountLabel.text = objUserSession.currency + (objPaymentManager?.totalAmount.withCommas())!
       
        self.paymentAmountLabel.text = objUserSession.currency + (objPaymentManager?.totalAmount.withCommas())!
       
        
        // self.setData()
        // Do any additional setup after loading the view.
    }
    func setData(){
        
        switch objPaymentManager?.reviewPaymentType {
        case .MobilePrepaidRecharge:
            self.serviceTitleLabel.text = "Mobile Number".localizeString()
            self.bharatBillAssuredImgView.isHidden = true
            break
        case.MobilePostpaidRecharge:
            self.serviceTitleLabel.text = "Mobile Number".localizeString()
            self.bharatBillAssuredImgView.isHidden = false
            break
        case .UtilityBills:
            self.bharatBillAssuredImgView.isHidden = false
            break
        case .none:
            
            break
        
        case .some(.UtilityBills):
            break
        }
    }
   
}
