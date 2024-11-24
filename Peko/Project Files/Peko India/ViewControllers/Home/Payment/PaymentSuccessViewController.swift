//
//  PaymentSuccessViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 12/12/23.
//

import UIKit

class PaymentSuccessViewController: MainViewController {

    @IBOutlet weak var animationView: PekoAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    
    var titleAttributeString:NSMutableAttributedString?
    var detailAttributeString:NSMutableAttributedString?
   // var screenTitle:String = ""
    
    static func storyboardInstance() -> PaymentSuccessViewController? {
        return AppStoryboards.Payment.instantiateViewController(identifier: "PaymentSuccessViewController") as? PaymentSuccessViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: objPaymentManager!.screenTitle)
        self.view.backgroundColor = .white
        
        self.titleLabel.attributedText = titleAttributeString
        self.detailLabel.attributedText = detailAttributeString
        
        self.animationView.setGIF(gifName: "payment_success.gif", loopCount: 1)
        self.animationView.delegate = self
        
        self.supportLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "For any queries or support, please contact us at ", font: AppFonts.Regular.size(size: 12), 5, .center).color(AppColors.blackThemeColor!, "support@peko.one", font: AppFonts.SemiBold.size(size: 12), 5, .center)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.animationView.startAnimation()
    }
}
// MARK: -
extension PaymentSuccessViewController:AnimationViewDelegate{
    func finishAnimation() {
        self.animationView.stopAnimation()
        if let receiptVC = PaymentReceiptDownloadViewController.storyboardInstance() {
            self.navigationController?.pushViewController(receiptVC, animated: true)
        }
    }
}
