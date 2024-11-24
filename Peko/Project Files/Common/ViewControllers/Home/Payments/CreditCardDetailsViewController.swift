//
//  CreditCardDetailsViewController.swift
//  Kash10
//
//  Created by Hardik Makwana on 22/08/24.
//

import UIKit
import Bolt

class CreditCardDetailsViewController: MainViewController {

    @IBOutlet weak var payButton: PekoButton!
    @IBOutlet weak var cardNumberView: CreditCardValidatorView!
    
    var creditCardView:CreditCardView?
    var finalAmount = 0.0
    let tokenizer = Bolt.CreditCardTokenizer()
   
    static func storyboardInstance() -> CreditCardDetailsViewController? {
        return AppStoryboards.Payment.instantiateViewController(identifier: "CreditCardDetailsViewController") as? CreditCardDetailsViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.isBackNavigationBarView = true
     
        self.setTitle(title: "Card Detail")
        
        self.cardNumberView.delegate = self
        
        let c1:UIColor = UIColor(rgb: 0x7CEA9C)
        let c2:UIColor = UIColor(rgb: 0x2FB799)
        let c3:UIColor = UIColor(rgb: 0x454851)
        
//        let c4:UIColor = UIColor(rgb: 0x6F73D2)
//        let c5:UIColor = UIColor(rgb: 0x98C1D9)
//        
        
        creditCardView = CreditCardView(frame: CGRect(x:25, y: 135, width: screenWidth - 50, height: screenWidth * 0.48),
                               template: .Basic(c1, c2, c3))
        self.view.addSubview(creditCardView!)
        // Do any additional setup after loading the view.
        
        payButton.setTitle("Pay " + objUserSession.currency + self.finalAmount.withCommas(), for: .normal)
        
        
        
    }
    // MARK: - Pay Now
    @IBAction func payNowButtonClick(_ sender: Any) {
        HPProgressHUD.show()
        tokenizer.generateToken(cardNumber: cardNumberView.cardNumberTextField.text!, cvv: cardNumberView.cvcTextField.text!) { result in
            HPProgressHUD.hide()
            switch result {
            case let .success(tokenizedCard):
                print(tokenizedCard)
            case let .failure(error):
                print(error)
            }
        }
    }
    
  
}

// MARK: - CreditCardDetailsViewController
extension CreditCardDetailsViewController: CreditCardValidatorViewDelegate {
    func didEdit(number: String) {
        self.creditCardView!.numLabel.text = number
        
        self.creditCardView?.brandImageView.image = cardNumberView.cardImageView.image
    }

    func didEdit(expiryDate: String) {
        // Play with expiry date
        self.creditCardView!.expLabel.text = expiryDate
    }

    func didEdit(cvc: String) {
        // Play with cvc
        self.creditCardView!.nameLabel.text = cvc
    }   
}
