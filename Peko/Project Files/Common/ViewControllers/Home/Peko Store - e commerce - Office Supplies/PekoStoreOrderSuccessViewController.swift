//
//  PekoStoreOrderSuccessViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 20/05/23.
//

import UIKit

class PekoStoreOrderSuccessViewController: MainViewController {

    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var supportLabel: UILabel!
    
    static func storyboardInstance() -> PekoStoreOrderSuccessViewController? {
        return AppStoryboards.PekoStore.instantiateViewController(identifier: "PekoStoreOrderSuccessViewController") as? PekoStoreOrderSuccessViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Office Supplies")
        
        self.detailLabel.attributedText = NSMutableAttributedString().color(.black, "The delivery executive will come to the pickup location soon to receive the item. Visit ", font: AppFonts.Regular.size(size: 12), 8, .center).underline(.black, "booking page ", font: AppFonts.Regular.size(size: 12)).color(.black, " for tracking\nThank you for using Peko", font: AppFonts.Regular.size(size: 12), 8, .center)
        
        self.supportLabel.attributedText = NSMutableAttributedString() .color(.black, "For any queries or support\nplease contact us at ", font: AppFonts.Regular.size(size: 10), 8, .center).color(.black, "support@peko.one", font: AppFonts.SemiBold.size(size: 10), 8, .center)
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func supportButtonClick(_ sender: Any) {
        self.supportMail()
    }
  
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

}
