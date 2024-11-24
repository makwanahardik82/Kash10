//
//  DU_PostpaidDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 09/02/23.
//

import UIKit

class DU_PostpaidDetailViewController: MainViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var denominationsLabel: UILabel!
  
    static func storyboardInstance() -> DU_PostpaidDetailViewController? {
        return AppStoryboards.Phone_Bill.instantiateViewController(identifier: "DU_PostpaidDetailViewController") as? DU_PostpaidDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        // serviceProvider
        self.setTitle(title:  "Du Postpaid")
        
        
        self.denominationsLabel.text = "Min: \(objPhoneBillsManager?.limitDataModel?.minDenomination ?? 0) AED and Max: \(objPhoneBillsManager?.limitDataModel?.maxDenomination ?? 0) AED"
      
        
        self.nameLabel.text = objPhoneBillsManager?.phoneBillRequest?.holder_name ?? ""
        self.numberLabel.text = objPhoneBillsManager?.phoneBillRequest?.number ?? ""
        // Do any additional setup after loading the view.
        
        // CHANGE FROM BALANCE
        self.amountTxt.text = objPhoneBillsManager?.balanceDataModel?.dueBalanceInAed ?? ""
    }
    // MARK: -
    @IBAction func editButtonClick(_ sender: Any) {
        self.amountTxt.becomeFirstResponder()
    }
    // MARK: - Pay Now button Click
    @IBAction func payNowButtonClick(_ sender: Any) {
        
        if(self.amountTxt.text!.isEmpty)
        {
            self.showAlert(title: "", message: "Please enter amount")
            return
        }
        let amount = Double(self.amountTxt.text ?? "0.0")
        let min = Double(objPhoneBillsManager?.limitDataModel?.minDenomination ?? 0)
        let max = Double(objPhoneBillsManager?.limitDataModel?.maxDenomination ?? 0)
        
        if(amount! < min || amount! > max)
        {
            self.showAlert(title: "", message: "Please enter an amount between min and max denominations")
            return
        }
        
        objPhoneBillsManager?.phoneBillRequest?.amount = self.amountTxt.text!
        
        if let chooseVC = PhoneBillChoosePaymentVC.storyboardInstance(){
            self.navigationController?.pushViewController(chooseVC, animated: true)
        }
    }
    
}
