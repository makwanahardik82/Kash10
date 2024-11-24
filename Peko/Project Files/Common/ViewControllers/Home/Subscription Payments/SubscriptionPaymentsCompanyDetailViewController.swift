//
//  SubscriptionPaymentsCompanyDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/03/24.
//

import UIKit
import PhoneCountryCodePicker

class SubscriptionPaymentsCompanyDetailViewController: MainViewController {

    @IBOutlet weak var planImgView: UIImageView!
    @IBOutlet weak var planDetailLabel: UILabel!
 
    @IBOutlet weak var companyNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var domainNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var adminEmailView: PekoFloatingTextFieldView!
    @IBOutlet weak var addressView: PekoFloatingTextView!
    @IBOutlet weak var countryView: PekoFloatingTextFieldView!
    
    static func storyboardInstance() -> SubscriptionPaymentsCompanyDetailViewController? {
        return AppStoryboards.SubscriptionPayments.instantiateViewController(identifier: "SubscriptionPaymentsCompanyDetailViewController") as? SubscriptionPaymentsCompanyDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Subscriptions")
        self.view.backgroundColor = .white
        
        self.countryView.delegate = self
        
        self.planImgView.sd_setImage(with: URL(string: ""))
        
        let name  = objSubscriptionPaymentManager?.plan?.name ?? ""
        let price = (objSubscriptionPaymentManager?.plan?.price ?? "0.0").toDouble()
        let type = objSubscriptionPaymentManager?.plan?.subscriptionType ?? ""
        let includes = (objSubscriptionPaymentManager?.plan?.includes ?? "")
        
        self.planDetailLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, name, font: .bold(size: 16), 5)
            .color(AppColors.blackThemeColor!, "\n" + objUserSession.currency + price.withCommas() + "/" + type, font: .bold(size: 14), 5)
            .color(.gray, includes, font: .regular(size: 12), 5)
    
        // Do any additional setup after loading the view.
    }
    // MARK: - Buy Now
    @IBAction func buyNowButtonClick(_ sender: Any) {
        
        let request = SubscriptionPaymentRequest(companyName: self.companyNameView.text!, domainName: self.domainNameView.text!, adminEmail: self.adminEmailView.text!, address: self.addressView.text, country: self.countryView.text!)
        
        let validationResult = SubscriptionPaymentValidation().ValidateSearch(request: request)

        if validationResult.success {
            self.view.endEditing(true)
            DispatchQueue.main.async {
                objSubscriptionPaymentManager?.request = request
                
                if let paymentReviewVC = PaymentReviewViewController.storyboardInstance() {
                    paymentReviewVC.paymentPayNow = .SubscriptionPayment
                    self.navigationController?.pushViewController(paymentReviewVC, animated: true)
                }
            }
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
        
        
    }
    
}
// MARK: - PekoFloatingTextFieldViewDelegate
extension SubscriptionPaymentsCompanyDetailViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        if textView == self.countryView {
            let vc = PCCPViewController() { countryDic in
                
                if let countryDic = countryDic as? [String:Any] {
                    
//                    if let code = countryDic["phone_code"] as? Int{
//                        self.phoneCodeLabel.text = "+\(code)"
//                    }
                    
                    if let cntname = countryDic["country_en"] as? String{
                        self.countryView.text = cntname
                       // self.setStatesArray(country: cntname)
                    }
//                    if let countryCode = countryDic["country_code"] as? String{
//                        DispatchQueue.main.async {
//                            let flag = PCCPViewController.image(forCountryCode: countryCode)
//                            self.flagImgView.image = flag
//                            self.mobileTxt.becomeFirstResponder()
//                        }
//                    }
                }
            }
            vc?.tableView.tintColor = .black
            let naviVC = UINavigationController(rootViewController: vc!)
            naviVC.modalPresentationStyle = .fullScreen
            self.present(naviVC, animated: true, completion: nil)
        }
    }
}
