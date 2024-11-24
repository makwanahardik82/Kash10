//
//  MobileRechargePlanViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 11/12/23.
//

import UIKit
import WDScrollableSegmentedControl

class MobileRechargePlanViewController: MainViewController {

    @IBOutlet weak var planTableView: UITableView!
    @IBOutlet weak var mobileNumberView: PekoFloatingTextFieldView!
    
    var planArray = [MobileRechargePlanModel]()
    
    static func storyboardInstance() -> MobileRechargePlanViewController? {
        return AppStoryboards.MobileRecharge.instantiateViewController(identifier: "MobileRechargePlanViewController") as? MobileRechargePlanViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: objMobileRechargeManager?.selectedOperatorModel?.operatorName ?? "")
        self.view.backgroundColor = .white
        
        self.planTableView.delegate = self
        self.planTableView.dataSource = self
        
        self.planTableView.backgroundColor = .white
        self.planTableView.separatorStyle = .none
        self.planTableView.separatorStyle = .none
        
        self.mobileNumberView.text = objMobileRechargeManager?.mobileNumber
        self.mobileNumberView.isUserInteractionEnabled = false
        self.mobileNumberView.phoneCodeLabel?.text = objMobileRechargeManager?.phoneCode
        
        self.getPlan()
    }
   // MARK: - Get Plan
    func getPlan(){
        HPProgressHUD.show()
        MobileRechargeModelView().getPlansList(product_id:objMobileRechargeManager?.selectedOperatorModel?.productId ?? 0) { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.success, status == true {
                
                DispatchQueue.main.async {
                    self.planArray = response?.products ?? [MobileRechargePlanModel]()
                    self.planTableView.reloadData()
                }
            }else{
                /*
                if let code = response?.responseCode, code == "002"{
                    self.showAlertWithCompletion(title: "", message: "Your session has expired, please login again.") { action in
                        
                        DispatchQueue.main.async {
                            objUserSession.logout()
                            objShareManager.navigateToViewController = .LoginVC
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeViewController"), object: nil)
                        }
                    }
                }
               
                else{
                 */
                    var msg = ""
                    if response?.message != nil {
                        msg = response?.message ?? ""
                    }
//                else if response?.error?.count != nil {
//                        msg = response?.error ?? ""
//                    }
                    self.showAlert(title: "", message: msg)
               // }
            }
        }
    }
}
extension MobileRechargePlanViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "MobilePlanTableViewCell", for: indexPath) as! MobilePlanTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let plan  = self.planArray[indexPath.row]
        cell.titleLabel.text = plan.productName ?? ""
        cell.priceLabel.text = (objMobileRechargeManager?.currencySymbol ?? "$ ") + (plan.max?.faceValue?.value ?? 0.0).withCommas()
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        objMobileRechargeManager!.selectedPlanModel = self.planArray[indexPath.row]
        
        if let vc = PaymentReviewViewController.storyboardInstance() {
            vc.paymentPayNow = .MobileRecharge
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}


// MARK: -
class MobilePlanTableViewCell:UITableViewCell {
    @IBOutlet weak var titleLabel: PekoLabel!
    
    @IBOutlet weak var priceLabel: PekoLabel!
    @IBOutlet weak var purchaseButton: PekoButton!
}
