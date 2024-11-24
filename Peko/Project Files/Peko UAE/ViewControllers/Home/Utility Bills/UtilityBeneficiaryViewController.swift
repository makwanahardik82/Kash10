//
//  UtilityBeneficiaryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 01/04/23.
//

import UIKit


class UtilityBeneficiaryViewController: MainViewController {

    @IBOutlet weak var bittlTitleLabel: PekoLabel!
    @IBOutlet weak var billsTableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var accountNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var amountView: PekoFloatingTextFieldView!
    @IBOutlet weak var pinView: PekoFloatingTextFieldView!
    
//    @IBOutlet weak var beneficiaryTableView: UITableView!
//  
//    @IBOutlet weak var segmentControl: PekoSegmentControl!
//     
//    @IBOutlet weak var scrollView: UIScrollView!
//  
//    @IBOutlet weak var accountNumberTxt: UITextField!
//    @IBOutlet weak var amountTxt: UITextField!
//    @IBOutlet weak var pinTxt: UITextField!
 
    @IBOutlet weak var denominationsLabel: UILabel!
    @IBOutlet weak var quickPayNowButton: UIButton!
   
////    @IBOutlet weak var accountNumberView: UIView!
////    @IBOutlet weak var amountView: UIView!
////    @IBOutlet weak var pinView: UIView!
////    
////    @IBOutlet weak var addBeneficiaryView: UIView!
////    
////    @IBOutlet weak var addBeneficiaryNameTxt: UITextField!
////    @IBOutlet weak var addBeneficiaryNumberTxt: UITextField!
////    @IBOutlet weak var addUpdateBeneficiary: UIButton!
////   
////    @IBOutlet weak var selectedBeneficiaryStackView: UIView!
//// 
////    @IBOutlet weak var selectedBeneficiaryNameTxt: UITextField!
////  
////    @IBOutlet weak var selectedBeneficiaryNameLabel: UILabel!
////    @IBOutlet weak var selectedBeneficiaryNumberLabel: UILabel!
////    @IBOutlet weak var beneficiaryStatusSwitch: UISwitch!
////    
////  
////    @IBOutlet weak var selectedBeneficiaryAmountView: UIView!
////    @IBOutlet weak var beneficiaryAmountTxt: UITextField!
////    @IBOutlet weak var selectedBeneficiaryDenominationsLabel: UILabel!
////    
//    
//    @IBOutlet weak var selectedBeneficiaryPinTypeView: UIView!
//    @IBOutlet weak var selectedBeneficiaryPinTypeTxt: UITextField!
//    
//    @IBOutlet weak var beneficiaryPayNowButton: UIButton!
//   
    
 //   var selectedBeneficiary:BeneficiaryModel?
    var beneficiaryArray = [BeneficiaryModel]()
    
   // var isUpdateBeneficiary = false
    
    static func storyboardInstance() -> UtilityBeneficiaryViewController? {
        return AppStoryboards.Utility.instantiateViewController(identifier: "UtilityBeneficiaryViewController") as? UtilityBeneficiaryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        let dic = Constants.utilityPaymentArray[objUtilityPaymentManager?.utilityPaymentType?.rawValue ?? 0]
        self.setTitle(title:  "Bill Payments")
        self.view.backgroundColor = .white
        // serviceProvider
        self.bittlTitleLabel.text = dic["title"] ?? ""//  (objUtilityPaymentManager!.limitDataModel?.serviceProvider ?? "")
        
        self.accountNumberView.isHidden = false
        self.amountView.isHidden = true
        self.pinView.isHidden = true
        self.accountNumberView.placeholder = "Account Number"
        self.denominationsLabel.text = ""
        
      
        
        if objUtilityPaymentManager?.utilityPaymentType == .Lootah_Gas {
            self.accountNumberView.placeholder = "Customer Number/Gas Account Number"
            self.accountNumberView.textField.keyboardType = .numbersAndPunctuation
        }else if objUtilityPaymentManager?.utilityPaymentType == .Salik {
            self.amountView.isHidden = false
            self.pinView.isHidden = false
            
            self.denominationsLabel.text = "Min: \(objUtilityPaymentManager?.limitDataModel?.minDenomination ?? 0) AED and Max: \(objUtilityPaymentManager?.limitDataModel?.maxDenomination ?? 0) AED"
            self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 450)
   
          }else if objUtilityPaymentManager?.utilityPaymentType == .Nol_Card {
            self.amountView.isHidden = false
            self.denominationsLabel.text = "Min: \(objUtilityPaymentManager?.limitDataModel?.minDenomination ?? 0) AED and Max: \(objUtilityPaymentManager?.limitDataModel?.maxDenomination ?? 0) AED"
              self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 380)
     
        }
//        else{
//            self.amountView.isHidden = true
//            self.pinView.isHidden = true
//
//            
//        }
        
        self.billsTableView.tableHeaderView = self.headerView
        self.billsTableView.backgroundColor = .clear
        self.billsTableView.delegate = self
        self.billsTableView.dataSource = self
        self.billsTableView.separatorStyle = .none
        self.billsTableView.register(UINib(nibName: "BillBeneficiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "BillBeneficiaryTableViewCell")
        
        self.getBeneficiaryList()
    }
    
  
    /*
    // MARK: - BENEFICIARY
    
    @IBAction func activeDeactiveBeneficiarySwitchClick(_ sender: UISwitch) {
   
        var beneficiary = self.selectedBeneficiary
        beneficiary?.isActive?.value = sender.isOn
        
        if let vc = BeneficiaryOTPViewController.storyboardInstance() {
            
            vc.isFromView = .UpdateUtilityBeneficiary
            vc.beneficiaryModel = beneficiary
            vc.completionBlock = { success, response in
                
                self.selectedBeneficiary = response
                self.selectedBeneficiary = beneficiary
                self.getBeneficiaryList()
                self.addBeneficiaryView.isHidden = true
                self.beneficiaryTableView.isHidden = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // MARK: - Edit Beneficiary
    @IBAction func editBaneficiaryButtonClick(_ sender: Any) {
        self.isUpdateBeneficiary = true
        
        self.addBeneficiaryNameTxt.text = self.selectedBeneficiary?.name
        self.addBeneficiaryNumberTxt.text = self.selectedBeneficiary?.accountNo
        
        self.addUpdateBeneficiary.setTitle("Update Beneficiary", for: .normal)
        
        self.addBeneficiaryView.isHidden = false
        self.beneficiaryTableView.isHidden = true
        
        
    }
    // MARK: - Delete Beneficiary
    @IBAction func deleteBeneficiaryButtonClick(_ sender: Any) {
        let action = UIAlertController(title: "Delete Beneficiary", message: "Are you sure to want to delete this beneficiary?", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.deleteBeneficiary()
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(action, animated: true)
        
    }
    // MARK: -
    @IBAction func addNewBeneficiaryButtonClick(_ sender: Any) {
        self.isUpdateBeneficiary = false
        
        self.addBeneficiaryNameTxt.text = ""
        self.addBeneficiaryNumberTxt.text = ""
        
        self.addUpdateBeneficiary.setTitle("Add Beneficiary", for: .normal)
        
        self.addBeneficiaryView.isHidden = false
        self.beneficiaryTableView.isHidden = true
        
        
    }
    // MARK: - Delete Beneficiary
    func     */
  // MARK: -
    
    @IBAction func addNewBeneficiaryButtonClick(_ sender: Any) {
        if let addVC = AddBeneficiaryViewController.storyboardInstance() {
            addVC.action = .UtilityBillAdd
            addVC.completionBlock = { beneficiary in
                self.beneficiaryArray.append(beneficiary)
                self.billsTableView.reloadData()
            }
            addVC.modalPresentationStyle = .overCurrentContext
            addVC.modalTransitionStyle = .crossDissolve
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(addVC, animated: false)
        }
    }
    
    /*
    @IBAction func saveNewBeneficiaryButtonClick(_ sender: Any) {
       
        let beneficiaryRequest = BeneficiaryRequest(name: self.addBeneficiaryNameTxt.text!, accountNo: self.addBeneficiaryNumberTxt.text!, accessKey: objUtilityPaymentManager?.limitDataModel?.accessKey)
        let validationResult = BeneficiaryValidation().Validate(beneficiaryRequest: beneficiaryRequest)
        self.view.endEditing(true)
        if validationResult.success {
           
            /*
            if self.isUpdateBeneficiary {
                var beneficiary = self.selectedBeneficiary
                beneficiary?.name = self.addBeneficiaryNameTxt.text!
                beneficiary?.accountNo = self.addBeneficiaryNumberTxt.text!
                self.updateBeneficiary(beneficiary: beneficiary!)
            }else{
                self.addBeneficiary(request: beneficiaryRequest)
            }
            */
            
            
            if let vc = BeneficiaryOTPViewController.storyboardInstance() {
                
                if self.isUpdateBeneficiary {
                    var beneficiary = self.selectedBeneficiary
                    beneficiary?.name = self.addBeneficiaryNameTxt.text!
                    beneficiary?.accountNo = self.addBeneficiaryNumberTxt.text!
                    
                    vc.isFromView = .UpdateUtilityBeneficiary
                    vc.beneficiaryModel = beneficiary
                    vc.completionBlock = { success, response in
                      
                        self.selectedBeneficiary = response
                        
                        self.selectedBeneficiary = beneficiary
                        self.getBeneficiaryList()
                        self.addBeneficiaryView.isHidden = true
                        self.beneficiaryTableView.isHidden = false
                         
                    }
                    //  self.updateBeneficiary(beneficiary: beneficiary!)
                }else{
                    vc.isFromView = .AddUtilityBeneficiary
                    vc.beneficiaryRequest = beneficiaryRequest
                    vc.completionBlock = { success, response in
                        
                        self.selectedBeneficiary = response // ?.first
                        
                        self.addBeneficiaryView.isHidden = true
                        self.beneficiaryTableView.isHidden = false
                        
                        self.setSelectedBeneficiary()
                        self.beneficiaryArray.append(self.selectedBeneficiary!)
                    }
                    //self.addBeneficiary(request: beneficiaryRequest)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    
    @IBAction func cancelBaneficiaryButtonClick(_ sender: Any) {
        self.addBeneficiaryView.isHidden = true
        self.beneficiaryTableView.isHidden = false
    }
    
    // MARK: - Beneficiary Drop Down
    @IBAction func selectBeneficiaryDropDownButtonClick(_ sender: Any) {
        if self.beneficiaryArray.count != 0 {
            if let beneficiaryVC = BeneficiaryViewController.storyboardInstance() {
                beneficiaryVC.beneficiaryArray = self.beneficiaryArray
                beneficiaryVC.completionBlock = { beneficiary in
                   // self.serviceTypeTxt.text = string
                    self.selectedBeneficiary = beneficiary
                    self.setSelectedBeneficiary()
                }
                self.present(beneficiaryVC, animated: true)
            }
        }else{
            self.showAlert(title: "No Beneficiary", message: "No Beneficiary, Please add your beneficiary")
        }
    }
    // MARK: - Set selected beneficiary
    func setSelectedBeneficiary(){
        if selectedBeneficiary != nil {
            self.selectedBeneficiaryNameTxt.text = self.selectedBeneficiary?.name
            
            self.selectedBeneficiaryNameLabel.text = self.selectedBeneficiary?.name
            self.selectedBeneficiaryNumberLabel.text = self.selectedBeneficiary?.accountNo
            
            self.beneficiaryStatusSwitch.isOn = self.selectedBeneficiary?.isActive?.value ?? false
            
            self.selectedBeneficiaryStackView.isHidden = false
          //  self.selectedBeneficiaryViewHeightConstraint.constant = 345
        }else{
            self.selectedBeneficiaryStackView.isHidden = true
            self.selectedBeneficiaryNameTxt.text = ""
       //     self.selectedBeneficiaryViewHeightConstraint.constant = 0
        }
    }
    */
    // MARK: - Get Beneficiary
    func getBeneficiaryList(){
        HPProgressHUD.show()
        UItilityBeneficiaryViewModel().getBeneficiary() { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
               // print("\n\n\n Balance is ", response?.data)
                //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    self.beneficiaryArray = (response?.data?.data)!
                    self.billsTableView.reloadData()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
                self.billsTableView.reloadData()
                //self.setSelectedBeneficiary()
            }
        }
    }
    
// MARK: - QUICK PAY
    // MARK: - Pay Now Button Click
    @IBAction func payNowButtonClick(_ sender: UIButton) {
        let utilityPaymentRequest:UtilityPaymentRequest = UtilityPaymentRequest(acoountNumber: self.accountNumberView.text!, amount: self.amountView.text!, pin: self.pinView.text!, holder_name: "N/A")

        self.validateRequest(request:utilityPaymentRequest)
    }
    func validateRequest(request:UtilityPaymentRequest){
        let validationResult = UtilityPaymentValidation().Validate(paymentRequest: request)

        if validationResult.success {
            objUtilityPaymentManager?.utilityPaymentRequest = request
            self.getBalance()
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    
    // MARK: - Get Balance Quick Pay
    func getBalance() {
        
        HPProgressHUD.show()
        
        
        UItilityBeneficiaryViewModel().getBalanceData { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    print("\n\n\n Balance is ", response?.data)
                    objUtilityPaymentManager!.balanceDataModel = response?.data!
                    self.goToDetailVC()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    func goToDetailVC() {
        if let detailVC = UtilityBillDetailViewController.storyboardInstance() {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    // MARK: - Go to Payment VC
    func goToPayment(){
        
        if let chooseVC = UtilityPaymentChoosePaymentVC.storyboardInstance(){
            self.navigationController?.pushViewController(chooseVC, animated: true)
        }
//        
//        if objUtilityPaymentManager?.phoneBillType == .DU_Postpaid || objUtilityPaymentManager?.phoneBillType == .Etisalat_Postpaid{
//            if let detailVC = DU_PostpaidDetailViewController.storyboardInstance() {
//                self.navigationController?.pushViewController(detailVC, animated: true)
//            }
//        }else{
//            
//        }
    }
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
/*
extension UtilityBeneficiaryViewController :UITextFieldDelegate {
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        if textField == self.accountNumberTxt {
            if objUtilityPaymentManager?.utilityPaymentType == .Lootah_Gas{
                return true
            }
            return textField.numberValidation(number: string)
        }
        return textField.decimalNumberValidation(number: string)
    }
}
// MARK: -
extension UtilityBeneficiaryViewController:PekoSegmentControlDelegate{
    func selectedSegmentIndex(index: Int) {
        self.scrollView.setContentOffset(CGPoint(x: Int(screenWidth) * (index - 1), y: 0), animated:true)
        
        if index == 1 {
            self.addBeneficiaryView.isHidden = true
        }else{
            self.addBeneficiaryView.isHidden = true
            self.beneficiaryTableView.isHidden = false
            
        }
    }
}
*/
// MARK: -
extension UtilityBeneficiaryViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beneficiaryArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillBeneficiaryTableViewCell") as! BillBeneficiaryTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let dic = beneficiaryArray[indexPath.row]
        
        cell.titleLabel.text = dic.name
        cell.detailLabel.text = dic.accountNo
        
        let tmp = "icon_utility_\(self.bittlTitleLabel.text ?? "")".lowercased().replacingOccurrences(of: " ", with: "_")
        cell.logoImgView.image = UIImage(named: tmp)
        cell.payNowButton.addAction(for: .touchUpInside) {
           
            let utilityPaymentRequest = UtilityPaymentRequest(acoountNumber: dic.accountNo, amount:"", pin: "", holder_name: dic.name)
            self.validateRequest(request: utilityPaymentRequest)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let actionVC = BeneficiaryActionViewController.storyboardInstance() {
            actionVC.completionBlock = { action in
                if action == .Edit {
                    if let addVC = AddBeneficiaryViewController.storyboardInstance() {
                        addVC.action = .UtilityBillUpdate
                        addVC.oldBeneficiaryModel = self.beneficiaryArray[indexPath.row]
                        addVC.completionBlock = { beneficiary in
                            self.beneficiaryArray[indexPath.row] = beneficiary
                            self.billsTableView.reloadData()
                        }
                        addVC.modalPresentationStyle = .overCurrentContext
                        addVC.modalTransitionStyle = .crossDissolve
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController!.present(addVC, animated: false)
                    }
                }else if action == .Delete {
                   // self.deleteBeneficiary(index: indexPath.row)
                    if let addVC = AddBeneficiaryViewController.storyboardInstance() {
                        addVC.action = .UtilityBillDelete
                        addVC.oldBeneficiaryModel = self.beneficiaryArray[indexPath.row]
                        addVC.deleteCompletionBlock = { success in
                            if success{
                                self.beneficiaryArray.remove(at: indexPath.row)
                                self.billsTableView.reloadData()
                            }
                        }
                        addVC.modalPresentationStyle = .overCurrentContext
                        addVC.modalTransitionStyle = .crossDissolve
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController!.present(addVC, animated: false)
                    }
                }
            }
            actionVC.modalPresentationStyle = .overCurrentContext
            actionVC.modalTransitionStyle = .crossDissolve
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(actionVC, animated: false)
        }
    }
    
    // MARK: -
    func deleteBeneficiary(index:Int){
        let dic = self.beneficiaryArray[index]
        HPProgressHUD.show()
        UItilityBeneficiaryViewModel().deleteBeneficiary(beneficiary_id: "\(dic.id ?? 0)") {  response, error  in
            
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.beneficiaryArray.remove(at: index)
                    self.billsTableView.reloadData()
                    self.showAlert(title: "Success", message: response?.message ?? "")
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
            
        }
    }

}
