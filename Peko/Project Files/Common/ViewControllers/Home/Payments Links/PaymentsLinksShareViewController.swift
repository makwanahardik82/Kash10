//
//  PaymentsLinksShareViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/05/23.
//

import UIKit

class PaymentsLinksShareViewController: MainViewController {

    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var urlView: PekoFloatingTextFieldView!
    // @IBOutlet weak var urlLabel: UILabel!
    
    var request:PaymentsLinksRequest?
    var paymentLink:String = ""
    
    static func storyboardInstance() -> PaymentsLinksShareViewController? {
        return AppStoryboards.PaymentsLinks.instantiateViewController(identifier: "PaymentsLinksShareViewController") as? PaymentsLinksShareViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Payments Links")
        self.view.backgroundColor = .white
        
        self.amountLabel.text = objUserSession.currency + (request?.amount ?? " ") // ?? ""
     //   self.descriptionLabel.text = request?.description ?? ""
        self.emailLabel.text = self.request?.email ?? ""
        self.phoneNumberLabel.text = self.request?.phoneNumber ?? ""
        self.createDateLabel.text = self.request?.createDate ?? ""
        
        if request!.noExpiry {
            self.expiryDateLabel.text = "No Expiry"
        }else{
            self.expiryDateLabel.text = self.request?.expiryDate
        }
        self.noteLabel.text = self.request?.note ?? ""
        self.urlView.text = paymentLink
        
        
        self.urlView.textField.isUserInteractionEnabled = false
        self.urlView.textField.textColor = .blue
        // Do any additional setup after loading the view.
    }
    // MARK: - Copy Button Click
    @IBAction func copyButtonClick(_ sender: Any) {
        UIPasteboard.general.string = self.urlView.text!
        self.showAlert(title: "", message: "Payment link copied")
    }

    // MARK: - Share Button Click
    @IBAction func shareButtonClick(_ sender: Any) {
        let items = [self.urlView.text!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
