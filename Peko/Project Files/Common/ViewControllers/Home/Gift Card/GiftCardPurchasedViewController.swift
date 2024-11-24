//
//  GiftCardPurchasedViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 13/05/23.
//

import UIKit

class GiftCardPurchasedViewController: MainViewController {

    @IBOutlet weak var thankLabel: UILabel!
    
    @IBOutlet weak var giftImgView: UIImageView!
    
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    
    @IBOutlet weak var supportLabel: UILabel!
    static func storyboardInstance() -> GiftCardPurchasedViewController? {
        return AppStoryboards.GiftCards.instantiateViewController(identifier: "GiftCardPurchasedViewController") as? GiftCardPurchasedViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.hidesBackButton = true
      
        self.isBackNavigationBarView = false
        self.setTitle(title: "Buy Gift Cards")
        self.view.backgroundColor = .white
        
        let str1 = "TITLE_CONFIRMATION_EMAIL".localizeString()
        let str2 = "TITLE_THANK_YOU_USING_PEKO".localizeString()
        
        self.thankLabel.attributedText = NSMutableAttributedString().color(.black, str1 + "\n" + str2, font: AppFonts.Light.size(size: 10), 5, .center)
        
        self.supportLabel.attributedText = NSMutableAttributedString().color(.black, "For any queries or support, please contact us at ", font: AppFonts.Regular.size(size: 10), 6, .center).color(.black, "support@peko.one", font: AppFonts.SemiBold.size(size: 10), 6, .center)
        
        
        self.giftNameLabel.text = objGiftCardManager?.productUAEModel?.name ?? ""
        self.giftImgView.sd_setImage(with: URL(string: (objGiftCardManager?.productUAEModel?.image ?? "")), placeholderImage: nil)
        
        self.detailLabel.attributedText = NSMutableAttributedString().color(.black, (objGiftCardManager?.productUAEModel?.description ?? "") + "\n\n" + ((objGiftCardManager?.productUAEModel?.description ?? "").html2AttributedString ?? ""), font: AppFonts.Regular.size(size: 10), 6, .center)
       
        
       // self.websiteLabel.text = "Use this gift card at \(objGiftCardManager?.productModel?.tnc?.link ?? "")"
        // Do any additional setup after loading the view.
    }

    // MARK: - View Code Button Click
    @IBAction func viewCodeButtonClick(_ sender: Any) {
   
    }
    
    // MARK: - Download Button Click
    @IBAction func downloadButtonClick(_ sender: Any) {
  
    }
    
    // MARK: - Back to Dashboard
    @IBAction func goBackToDashboardButtonClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
