//
//  PaymentSuccessViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 13/02/24.
//

import UIKit
import Lottie

class PaymentSuccessViewController: MainViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
   // @IBOutlet weak var animationView: PekoAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    
    var titleAttributeString:NSMutableAttributedString?
    var detailAttributeString:NSMutableAttributedString?
    var screenTitle:String = ""
    
    static func storyboardInstance() -> PaymentSuccessViewController? {
        return AppStoryboards.Payment.instantiateViewController(identifier: "PaymentSuccessViewController") as? PaymentSuccessViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.isBackNavigationBarView = true
        self.setTitle(title: screenTitle)
        self.view.backgroundColor = .white
      
        animationView.loopMode = .loop
        animationView.play()
        
        self.titleLabel.attributedText = self.titleAttributeString
        self.detailLabel.attributedText = self.detailAttributeString
        self.supportLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "For any queries or support, please contact us at ", font: AppFonts.Regular.size(size: 12), 5, .center).color(AppColors.blackThemeColor!, "support@peko.one", font: AppFonts.SemiBold.size(size: 12), 5, .center)
        
        
    }
    // MARK: - Download Invoice
    @IBAction func downloadInvoiceButtonClick(_ sender: Any) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
      //  self.animationView.startAnimation()
    }
}
