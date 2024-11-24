//
//  MobileRechargeViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 11/12/23.
//

import UIKit


class MobileRechargeViewController: MainViewController {
   
    @IBOutlet weak var mobileNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var operatorNameLabel: PekoLabel!
    
    var currencySymbol = "$ "
    
    static func storyboardInstance() -> MobileRechargeViewController? {
        return AppStoryboards.MobileRecharge.instantiateViewController(identifier: "MobileRechargeViewController") as? MobileRechargeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Mobile Recharge")
        self.view.backgroundColor = .white
        
        self.operatorNameLabel.text = objMobileRechargeManager?.selectedOperatorModel?.operatorName ?? ""
        mobileNumberView.phoneCodeLabel?.text = objMobileRechargeManager?.phoneCode
    }
    
    // MARK: - Continue Button Click
    @IBAction func continueButtonClick(_ sender: UIButton) {
        
        if self.mobileNumberView.text?.count == 0 {
            self.showAlert(title: "", message: "Please enter mobile number")
            return
        }
        
        objMobileRechargeManager?.mobileNumber = self.mobileNumberView.text!
        
        if let vc = MobileRechargePlanViewController.storyboardInstance() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
