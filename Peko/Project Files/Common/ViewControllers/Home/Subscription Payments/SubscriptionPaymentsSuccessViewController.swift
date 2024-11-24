//
//  SubscriptionPaymentsSuccessViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 20/07/23.
//

import UIKit

class SubscriptionPaymentsSuccessViewController: MainViewController {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var supportMailLabel: UILabel!
    
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
 
    @IBOutlet weak var productDescLabel: UILabel!
    
    @IBOutlet weak var currentPlanLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var billingCycleLabel: UILabel!
    @IBOutlet weak var compnyNameLabel: UILabel!
    
    static func storyboardInstance() -> SubscriptionPaymentsSuccessViewController? {
        return AppStoryboards.SubscriptionPayments.instantiateViewController(identifier: "SubscriptionPaymentsSuccessViewController") as? SubscriptionPaymentsSuccessViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Subscriptions")
     
        self.isBackNavigationBarView = false
        self.navigationItem.hidesBackButton = true
        
        DispatchQueue.main.async {
            
            self.descLabel.attributedText = NSMutableAttributedString().color(.black, "You will receive a confirmation email\nonce the payment process is completed.\n Thank you for using Peko.", font: AppFonts.Regular.size(size: 12), 5, .center)
                            
            self.supportMailLabel.attributedText = NSMutableAttributedString().color(.black, "For any queries or support, please contact us at ", font: AppFonts.Regular.size(size: 15), 8, .center).color(.black, Constants.support_email, font: AppFonts.SemiBold.size(size: 15), 8, .center)
           
            
            self.productImgView.sd_setImage(with: URL(string: objSubscriptionPaymentManager?.product?.productImage ?? ""), placeholderImage: nil)
            self.productNameLabel.text = objSubscriptionPaymentManager?.product?.name ?? ""
            self.productDescLabel.text = objSubscriptionPaymentManager?.product?.description ?? ""
            
            let validity = objSubscriptionPaymentManager?.plan?.validity ?? "0"
            let perMonth = Double(objSubscriptionPaymentManager?.plan?.price ?? "0")! / Double(validity)!
          
            self.currentPlanLabel.text = "\(objUserSession.currency) \(perMonth.withCommas())/mo"
            self.billingCycleLabel.text = "\(validity) Months"
            self.compnyNameLabel.text = objUserSession.profileDetail?.companyName ?? ""
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - SIGN IN
    @IBAction func signInButtonClick(_ sender: Any) {
  
    }
    
    // MARK: - Send Mail Button
    @IBAction func sendMailButtonClick(_ sender: Any) {
        self.supportMail()
    }
    
    // MARK: - Go Back to Dashboard
    @IBAction func goBackToDashboardClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
