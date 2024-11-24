//
//  TransactionDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 31/03/23.
//

import UIKit

class TransactionDetailViewController: MainViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var totalPaymentLabel: PekoLabel!
    
    @IBOutlet weak var totalCashbackLabel: PekoLabel!
    
    @IBOutlet weak var cashbackStackView: UIStackView!
    
    @IBOutlet weak var transactionIdLabel: PekoLabel!
    @IBOutlet weak var dateLabel: PekoLabel!
    @IBOutlet weak var timeLabel: PekoLabel!
    @IBOutlet weak var serviceLabel: PekoLabel!
    @IBOutlet weak var servicePorviderLabel: PekoLabel!
    
    @IBOutlet weak var paymentModeLabel: PekoLabel!
    @IBOutlet weak var statusLabel: PekoLabel!
    
    var transactionModel:TransactionModel?
    
    static func storyboardInstance() -> TransactionDetailViewController? {
        return AppStoryboards.Transactions.instantiateViewController(identifier: "TransactionDetailViewController") as? TransactionDetailViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = AppColors.blackThemeColor?.withAlphaComponent(0.8)
      
        let bill_amount = transactionModel?.order?.amountInAed?.toDouble()
        let cashback_amount = (transactionModel?.corporateCashback ?? "0.0").toDouble()
      
        if cashback_amount == 0.0 {
            self.cashbackStackView.isHidden = true
        }else{
            self.cashbackStackView.isHidden = false
            self.totalCashbackLabel.text = objUserSession.currency + "+ " + (cashback_amount.decimalPoints())
        }
        self.totalPaymentLabel.text = objUserSession.currency + (bill_amount?.withCommas() ?? "")
        
        self.transactionIdLabel.text = transactionModel?.corporateTxnId ?? ""
        self.dateLabel.text = transactionModel?.date.formate(format: "dd MMMM’yy")
        self.timeLabel.text = transactionModel?.date.formate(format: "hh:mm a")
       
        self.serviceLabel.text = transactionModel?.transactionCategory ?? ""
        self.servicePorviderLabel.text = transactionModel?.serviceOperator?.serviceProvider ?? ""
        
        self.paymentModeLabel.text = (transactionModel?.order?.paymentMode ?? "").capitalized
        self.statusLabel.text = (transactionModel?.order?.status ?? "").capitalized
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        self.animation()
    }
    
    // MARK: - ANIMATION
    func animation(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn, // curveEaseIn
                       animations: { () -> Void in
            
          //  self.superview?.layoutIfNeeded()
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            
        })
    }
    
    @IBAction func downloadInvoiceButtonClick(_ sender: Any) {
   
    }
    
    @IBAction func supportButtonClick(_ sender: Any) {
        self.supportMail()
    }
    
// MARK: - Cancel Button Click
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: false)
    }
}
