//
//  PhoneBillReceiptViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 20/01/23.
//

import UIKit
import MessageUI


enum Is_From: Int {
    case PhoneBill = 0
    case PayLater
    case License
    case UtilityPayment
}


class PaymentReceiptViewController: MainViewController {

    @IBOutlet weak var message1Label: UILabel!
    @IBOutlet weak var message2Label: UILabel!
   
    @IBOutlet weak var successImgView: UIImageView!
   
    var isFrom = Is_From(rawValue: 0)
    
    static func storyboardInstance() -> PaymentReceiptViewController? {
        return AppStoryboards.Common.instantiateViewController(identifier: "PaymentReceiptViewController") as? PaymentReceiptViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.isPopToRoot = true
        self.isBackNavigationBarView = false
        
      //  self.navigationItem.hidesBackButton = true
       // self.isNavigationTitle = false
        
       // self.setTitle(title:"Successful")
//
//        self.isNavigationTitle = true
        
        
        switch isFrom {
        case .PhoneBill:
            DispatchQueue.main.async {
                self.message1Label.attributedText = NSMutableAttributedString().color(.black, "Your top-up for ", font: AppFonts.Regular.size(size: 14), 8, .center).color(.black, "+971 \(objPhoneBillsManager?.phoneBillRequest?.number ?? "")", font: AppFonts.SemiBold.size(size: 14), 8, .center).color(.black, " is successful. You will receive a confirmation email once the process is completed. Thank you for using Peko.", font: AppFonts.Regular.size(size: 14), 8, .center)
            
            }
            break
        case .PayLater:
            DispatchQueue.main.async {
                self.message1Label.attributedText =
                NSMutableAttributedString().color(.black, "Payment Done!\n", font: AppFonts.SemiBold.size(size: 15), 8, .center).color(.black, "Your request for Pay Later is request is done. You will receive a confirmation email once the process is completed. Thank you for using Peko.", font: AppFonts.Regular.size(size: 14), 8, .center)
            }
            break
        case .License:
            DispatchQueue.main.async {
                self.message1Label.attributedText =
                NSMutableAttributedString().color(.black, "Your request for DED License Renewal is done, you will receive a confirmation email once the process is completed. Thank you for using Peko.", font: AppFonts.Regular.size(size: 14), 8, .center)
                
              //  self.successImgView.image = UIImage(named: "icon_license_payment_success")
            }
            break
      
        case .UtilityPayment:
            DispatchQueue.main.async {
                self.message1Label.attributedText = NSMutableAttributedString().color(.black, "Your payment for ", font: AppFonts.Regular.size(size: 14), 8, .center).color(.black, " \(objUtilityPaymentManager?.utilityPaymentRequest?.acoountNumber ?? "")", font: AppFonts.SemiBold.size(size: 14), 8, .center).color(.black, " is successful. You will receive a confirmation email once the process is completed. Thank you for using Peko.", font: AppFonts.Regular.size(size: 14), 8, .center)
            }
            break
        case .none:
            break
        }
        
        
       
        DispatchQueue.main.async {
            self.message2Label.attributedText = NSMutableAttributedString().color(.black, "For any queries or support, please contact us at ", font: AppFonts.Regular.size(size: 15), 8, .center).color(.black, Constants.support_email, font: AppFonts.SemiBold.size(size: 15), 8, .center)
        }
      
        
       
         
    }
    override func viewWillDisappear(_ animated: Bool) {
//        if isMovingFromParent {
//            self.navigationController?.popToRootViewController(animated: false)
//        }
    }
    
    // MARK: -
    @IBAction func backToDashboardButtonClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
// MARK: - Mail Button Click
    @IBAction func supportMailButtonCLick(_ sender: Any) {
        self.supportMail()
    }
    
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}

