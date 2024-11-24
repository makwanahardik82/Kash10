//
//  PhoneBillBeneficiaryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/01/23.
//

import UIKit


class PhoneBillBeneficiaryViewController: MainViewController {

//    @IBOutlet weak var beneficiaryTableView: UITableView!
//  
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var addBeneficiaryView: UIView!
    
//    @IBOutlet weak var serviceTypeTxt: UITextField!
//    @IBOutlet weak var quickNumberTxt: UITextField!
//    @IBOutlet weak var quickPayAmountTxt: UITextField!
   // @IBOutlet weak var beneficiaryAmountTxt: UITextField!
   
    @IBOutlet weak var denominationsLabel: UILabel!
   
//    @IBOutlet weak var serviceTypeView: UIView!
//    @IBOutlet weak var holderNameView: UIView!
//    @IBOutlet weak var holderNameTxt: UITextField!
//  
//    @IBOutlet weak var amountView: UIView!
//    
    @IBOutlet weak var quickPayNowButton: UIButton!
    /*
    @IBOutlet weak var selectedBeneficiaryServiceTypeView: UIView!
    @IBOutlet weak var selectedBeneficiaryAmountView: UIView!
    @IBOutlet weak var selectedBeneficiaryServiceTypeTxt: UITextField!
    
    @IBOutlet weak var selectedBeneficiaryNameTxt: UITextField!
    @IBOutlet weak var selectedBeneficiaryDenominationsLabel: UILabel!
   
    @IBOutlet weak var addUpdateBeneficiary: UIButton!
    
    @IBOutlet weak var selectedBeneficiaryStackView: UIView!
  
    @IBOutlet weak var selectedBeneficiaryNameLabel: UILabel!
    @IBOutlet weak var selectedBeneficiaryNumberLabel: UILabel!
    
    @IBOutlet weak var beneficiaryStatusSwitch: UISwitch!
    
    @IBOutlet weak var newBeneficiaryNameTxt: UITextField!
    @IBOutlet weak var newBeneficiaryNumberTxt: UITextField!
    
    @IBOutlet weak var beneficiaryPayNowButton: UIButton!
    
    @IBOutlet weak var segmentControl: PekoSegmentControl!
       
    @IBOutlet weak var resendOtpButton: UIButton!
    
    @IBOutlet weak var otpView: PekoOTPView!
    @IBOutlet weak var resendOtpView: UIView!
    */
    
    
    @IBOutlet weak var billTitleLabel: PekoLabel!
    @IBOutlet weak var billTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
   
    @IBOutlet weak var serviceTypeView: PekoFloatingTextFieldView!
    @IBOutlet weak var mobileNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var amountView: PekoFloatingTextFieldView!
    
    
 //   var selectedBeneficiary:BeneficiaryModel?
    var beneficiaryArray = [BeneficiaryModel]()
  //  var beneficiaryRequest:BeneficiaryRequest?
    //   var dic:[String:String]?
    
//    var isUpdateBeneficiary = false
//    var timer:Timer?
//    var totalSecond = 61
//    
    static func storyboardInstance() -> PhoneBillBeneficiaryViewController? {
        return AppStoryboards.Phone_Bill.instantiateViewController(identifier: "PhoneBillBeneficiaryViewController") as? PhoneBillBeneficiaryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title:  "Bill Payments")
        self.view.backgroundColor = .white
        // serviceProvider
        self.billTitleLabel.text = (objPhoneBillsManager!.limitDataModel?.serviceProvider ?? "")
        
      //  self.selectedBeneficiaryDenominationsLabel.text = "Min: \(objPhoneBillsManager?.limitDataModel?.minDenomination ?? 0) AED and Max: \(objPhoneBillsManager?.limitDataModel?.maxDenomination ?? 0) AED"
        
        if objPhoneBillsManager?.phoneBillType == .DU_Postpaid {
            self.serviceTypeView.isHidden = true
            self.amountView.isHidden = true
         //   self.holderNameView.isHidden = true
            
//            self.selectedBeneficiaryServiceTypeView.isHidden = true
//            self.selectedBeneficiaryAmountView.isHidden = true
//            
          //  self.quickPayNowButton.setTitle("View Bill", for: .normal)
          //  self.beneficiaryPayNowButton.setTitle("View Bill", for: .normal)
            self.denominationsLabel.isHidden = true
            
            self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 300)
            
        }else if objPhoneBillsManager?.phoneBillType == .Etisalat_Postpaid {
            self.serviceTypeView.isHidden = false
            self.amountView.isHidden = true
        //    self.holderNameView.isHidden = true
            
//            self.selectedBeneficiaryServiceTypeView.isHidden = false
//            self.selectedBeneficiaryAmountView.isHidden = true
//            
          //  self.quickPayNowButton.setTitle("View Bill", for: .normal)
          //  self.beneficiaryPayNowButton.setTitle("View Bill", for: .normal)
            self.denominationsLabel.isHidden = true
            
            self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 380)
            
        }else{
            self.serviceTypeView.isHidden = false
            self.amountView.isHidden = false
        //    self.holderNameView.isHidden = true
            
//            self.selectedBeneficiaryServiceTypeView.isHidden = false
//            self.selectedBeneficiaryAmountView.isHidden = false
//            
           // self.quickPayNowButton.setTitle("Pay Now", for: .normal)
           // self.beneficiaryPayNowButton.setTitle("Pay Now", for: .normal)
            self.denominationsLabel.isHidden = false
           
            self.denominationsLabel.text = "Min: \(objPhoneBillsManager?.limitDataModel?.minDenomination ?? 0) AED and Max: \(objPhoneBillsManager?.limitDataModel?.maxDenomination ?? 0) AED"
          
            self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 450)
        }
        
        
        self.serviceTypeView.delegate = self
        
        self.billTableView.tableHeaderView = self.headerView
        self.billTableView.backgroundColor = .clear
        self.billTableView.delegate = self
        self.billTableView.dataSource = self
        self.billTableView.separatorStyle = .none
        self.billTableView.register(UINib(nibName: "BillBeneficiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "BillBeneficiaryTableViewCell")
        
        self.getBeneficiaryList()
        
      //  self.newBeneficiaryNumberTxt.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    // MARK: - Get Beneficiary
    func getBeneficiaryList(){
        HPProgressHUD.show()
        PhoneBillBeneficiaryViewModel().getBeneficiary() { response, error in
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
                    self.billTableView.reloadData()
                  //  self.setSelectedBeneficiary()
                   
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
//                self.setSelectedBeneficiary()
                self.billTableView.reloadData()
            }
        }
    }
  
    // MARK: - Add /Edit Beneficiary
    @IBAction func addBeneficiaryButtonClick(_ sender: Any) {
        if let addVC = AddBeneficiaryViewController.storyboardInstance() {
            addVC.action = .PhoneBillAdd
            addVC.completionBlock = { beneficiary in
                self.beneficiaryArray.append(beneficiary)
                self.billTableView.reloadData()
            }
            addVC.modalPresentationStyle = .overCurrentContext
            addVC.modalTransitionStyle = .crossDissolve
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(addVC, animated: false)
        }
    }
    
    /*
    @IBAction func editBaneficiaryButtonClick(_ sender: Any) {
        self.isUpdateBeneficiary = true
        
        self.newBeneficiaryNameTxt.text = self.selectedBeneficiary?.name
        self.newBeneficiaryNumberTxt.text = self.selectedBeneficiary?.accountNo
        
       // self.addUpdateBeneficiary.setTitle("Update Beneficiary", for: .normal)
        
        self.addBeneficiaryView.isHidden = false
        self.beneficiaryTableView.isHidden = true
        self.addUpdateBeneficiary.setTitle("Send OTP", for: .normal)
       
        self.otpView.isHidden = true
        self.resendOtpView.isHidden = true
        self.resendOtpButton.setTitle("01:00", for: .normal)
        self.resendOtpButton.isUserInteractionEnabled = false
        self.otpView.clearOTP()
    }
    
    @IBAction func activeDeactiveBeneficiarySwitchClick(_ sender: UISwitch) {

        var beneficiary = self.selectedBeneficiary
        beneficiary?.isActive?.value = sender.isOn
      //  self.updateBeneficiary(beneficiary: beneficiary!)
        if let vc = BeneficiaryOTPViewController.storyboardInstance() {
            
            vc.isFromView = .UpdatePhoneBillBeneficiary
            vc.beneficiaryModel = beneficiary
            vc.completionBlock = { success, response in
                self.selectedBeneficiary = response
                self.getBeneficiaryList()
                self.addBeneficiaryView.isHidden = true
                self.beneficiaryTableView.isHidden = false
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        
        self.newBeneficiaryNameTxt.text = ""
        self.newBeneficiaryNumberTxt.text = ""
        
        self.addUpdateBeneficiary.setTitle("Send OTP", for: .normal)
        
        self.addBeneficiaryView.isHidden = false
        self.beneficiaryTableView.isHidden = true
        
        self.otpView.isHidden = true
        self.resendOtpView.isHidden = true
        self.resendOtpButton.setTitle("01:00", for: .normal)
        self.otpView.clearOTP()
    }
    
    
    // MARK: - 
    @IBAction func saveNewBeneficiaryButtonClick(_ sender: Any) {
       
        let beneficiaryRequest = BeneficiaryRequest(name: self.newBeneficiaryNameTxt.text!, accountNo: self.newBeneficiaryNumberTxt.text!, accessKey: objPhoneBillsManager?.limitDataModel?.accessKey)
        
        let validationResult = BeneficiaryValidation().Validate(beneficiaryRequest: beneficiaryRequest)
        self.view.endEditing(true)
        
        if validationResult.success {
            
            let str = self.addUpdateBeneficiary.titleLabel?.text
            
            if str == "Send OTP" {
                self.sendOTP()
            }else{
                
                if self.otpView.otpString.count != 6 {
                    self.showAlert(title: "", message: "Please enter OTP")
                }else{
                    if self.isUpdateBeneficiary {
                        var request:BeneficiaryModel = self.selectedBeneficiary!
                        request.name = self.newBeneficiaryNameTxt.text!
                        request.accountNo = self.newBeneficiaryNumberTxt.text!
                        self.updatePhoneBillBeneficiary(request: request)
                    }else{
                        self.addPhoneBillBeneficiary(beneficiaryRequest: beneficiaryRequest)
                    }
                }
                
            }
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    
    @IBAction func cancelBaneficiaryButtonClick(_ sender: Any) {
        self.addBeneficiaryView.isHidden = true
        self.beneficiaryTableView.isHidden = false
        
        self.invalidateTimer()
        
    }
    */
   
    // MARK: - Pay Now Button Click
    @IBAction func payNowButtonClick(_ sender: UIButton) {
        let serviceType = objPhoneBillsManager!.serviceTypeValueDictionary[self.serviceTypeView.text!]
        
        let phoneBillRequest = PhoneBillRequest(number: self.mobileNumberView.text!, amount: self.amountView.text!, service_type: serviceType, holder_name: "N/A")
        self.validateRequest(request: phoneBillRequest)
    }
    func validateRequest(request:PhoneBillRequest) {
        let validationResult = PhoneBillValidation().Validate(billRequest: request)

        if validationResult.success {
            objPhoneBillsManager?.phoneBillRequest = request
            self.getBalance()
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    // MARK: - Quick Pay - Get Balance
    func getBalance() {
        
        HPProgressHUD.show()
        
        PhoneBillBeneficiaryViewModel().getBalanceData() { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
             //   print("\n\n\n Balance is ", response??.data)
                //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    objPhoneBillsManager!.balanceDataModel = response?.data!
                    self.goToPayment()
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
    
    // MARK: - Go to Payment VC
    func goToPayment(){
        
        if let detailVC = PhoneBillDetailViewController.storyboardInstance() {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        /*
        if objPhoneBillsManager?.phoneBillType == .DU_Postpaid || objPhoneBillsManager?.phoneBillType == .Etisalat_Postpaid{
            if let detailVC = DU_PostpaidDetailViewController.storyboardInstance() {
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }else{
            if let chooseVC = PhoneBillChoosePaymentVC.storyboardInstance(){
                self.navigationController?.pushViewController(chooseVC, animated: true)
            }
        }
        */
    }
  
    
    /*
    
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
    
   
    
    
    
    
    
    // MARK: -
    @IBAction func resendOTPButtonClick(_ sender: Any) {
        self.sendOTP()
    }
    // MARK: - SEND OTP
    func sendOTP(){
        HPProgressHUD.show()
        OTPViewModel().generateOTPForBeneficiary() {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if response?.status ?? false {
                DispatchQueue.main.async {
                    if self.isUpdateBeneficiary {
                        self.addUpdateBeneficiary.setTitle("Update Beneficiary", for: .normal)
                       
                    }else{
                        self.addUpdateBeneficiary.setTitle("Save Beneficiary", for: .normal)
                       
                    }
                    self.totalSecond = 61
                    self.updateResendLabel()
                    self.startTimer()
                    self.otpView.isHidden = false
                    self.resendOtpView.isHidden = false
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
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateResendLabel), userInfo: nil, repeats: true)
    }
    
    func invalidateTimer(){
        if timer != nil {
            timer?.invalidate()
        }
    }
    // MARK: -
    @objc func updateResendLabel()  {
        totalSecond = totalSecond - 1
       // let attr = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Resend in ",font: AppFonts.Regular.size(size: 12), 5, .center).color(.black, "\(self.totalSecond)", font: AppFonts.Medium.size(size: 12), 5, .center).color(.black, " Sec", font: AppFonts.Regular.size(size: 12), 5, .center)
        // Resending in 1.29 sec
     
        self.resendOtpButton.setTitle(self.totalSecond.timeString(), for: .normal)
        
        if totalSecond == 0 {
            self.invalidateTimer()
            self.resendOtpButton.setTitle("Resend", for: .normal)
            self.resendOtpButton.isUserInteractionEnabled = true
        }
    }
    
    // MARK: -
    func updatePhoneBillBeneficiary(request:BeneficiaryModel){
        
        HPProgressHUD.show()
        PhoneBillBeneficiaryViewModel().updateBeneficiary(request: self.selectedBeneficiary!, otpString: self.otpView.otpString) {  response in
         
            HPProgressHUD.hide()
            if let status = response.status, status == true {
                DispatchQueue.main.async {
                    self.getBeneficiaryList()
                    self.addBeneficiaryView.isHidden = true
                    self.beneficiaryTableView.isHidden = false
                    self.invalidateTimer()
                    self.otpView.clearOTP()
                }
            }else{
                var msg = ""
                if response.message != nil {
                    msg = response.message ?? ""
                }else if response.error?.count != nil {
                    msg = response.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    func addPhoneBillBeneficiary(beneficiaryRequest:BeneficiaryRequest){
        HPProgressHUD.show()
        PhoneBillBeneficiaryViewModel().addBeneficiary(request: beneficiaryRequest, otpString: self.otpView.otpString) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    self.addBeneficiaryView.isHidden = true
                    self.beneficiaryTableView.isHidden = false
                    self.selectedBeneficiary = response?.data! // ?.first
                    self.setSelectedBeneficiary()
                    self.beneficiaryArray.append(self.selectedBeneficiary!)
                    self.invalidateTimer()
                    self.otpView.clearOTP()
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
    */
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
/*
extension PhoneBillBeneficiaryViewController :UITextFieldDelegate {
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        if textField == self.quickNumberTxt {
            return textField.numberValidation(number: string)
        }else if textField == self.newBeneficiaryNumberTxt {
            return textField.numberValidation(number: string)
        }
        return textField.decimalNumberValidation(number: string)

    }

}
*/

// MARK: -
extension PhoneBillBeneficiaryViewController:UITableViewDelegate, UITableViewDataSource {
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
        
        if objPhoneBillsManager?.phoneBillType == .DU_Postpaid || objPhoneBillsManager?.phoneBillType == .DU_Prepaid {
            cell.logoImgView.image = UIImage(named: "icon_phone_bill_du")
        }else{
            cell.logoImgView.image = UIImage(named: "icon_phone_bill_etisalat")
        }
        
        cell.payNowButton.addAction(for: .touchUpInside) {
            // HARDIK
          let phoneBillRequest = PhoneBillRequest(number: dic.accountNo, amount: "", service_type: "", holder_name: dic.name)
            self.validateRequest(request: phoneBillRequest)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let actionVC = BeneficiaryActionViewController.storyboardInstance() {
            actionVC.completionBlock = { action in
                if action == .Edit {
                    if let addVC = AddBeneficiaryViewController.storyboardInstance() {
                        addVC.action = .PhoneBillUpdate
                        addVC.oldBeneficiaryModel = self.beneficiaryArray[indexPath.row]
                        addVC.completionBlock = { beneficiary in
                            self.beneficiaryArray[indexPath.row] = beneficiary
                            self.billTableView.reloadData()
                        }
                        addVC.modalPresentationStyle = .overCurrentContext
                        addVC.modalTransitionStyle = .crossDissolve
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController!.present(addVC, animated: false)
                    }
                }else if action == .Delete {
                  //  self.deleteBeneficiary(index: indexPath.row)
                    
                    if let addVC = AddBeneficiaryViewController.storyboardInstance() {
                        addVC.action = .PhoneBillDelete
                        addVC.oldBeneficiaryModel = self.beneficiaryArray[indexPath.row]
                        addVC.deleteCompletionBlock = { isDelete in
                            
                            if isDelete {
                                self.beneficiaryArray.remove(at: indexPath.row)
                                self.billTableView.reloadData()
                              //  self.showAlert(title: "Success", message: response?.message ?? "")
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
        
        /*
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        action.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            if let addVC = AddBeneficiaryViewController.storyboardInstance() {
                addVC.action = .PhoneBillUpdate
                addVC.oldBeneficiaryModel = self.beneficiaryArray[indexPath.row]
                addVC.completionBlock = { beneficiary in
                    self.beneficiaryArray[indexPath.row] = beneficiary
                    self.billTableView.reloadData()
                }
                addVC.modalPresentationStyle = .overCurrentContext
                addVC.modalTransitionStyle = .crossDissolve
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController!.present(addVC, animated: false)
            }
        }))
        
        action.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.deleteBeneficiary(index: indexPath.row)
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(action, animated: true)
        */
    }
    // MARK: - Delete Beneficiary
    func deleteBeneficiary(index:Int){
        let dic = beneficiaryArray[index]
       
        
        HPProgressHUD.show()
        PhoneBillBeneficiaryViewModel().deleteBeneficiary(beneficiary_id: "\(dic.id ?? 0)") {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.beneficiaryArray.remove(at: index)
                    self.billTableView.reloadData()
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
//
extension PhoneBillBeneficiaryViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        if textView == self.serviceTypeView {
            let pickerVC = PickerListViewController.storyboardInstance()
            
            if objPhoneBillsManager?.phoneBillType == .DU_Prepaid {
                pickerVC?.array = objPhoneBillsManager!.duPrePaidServiceTypeArray
            }else if objPhoneBillsManager?.phoneBillType == .Etisalat_Prepaid {
                pickerVC?.array = objPhoneBillsManager!.etisalatPrePaidServiceTypeArray
            }else if objPhoneBillsManager?.phoneBillType == .Etisalat_Postpaid{
                pickerVC?.array = objPhoneBillsManager!.etisalatPostPaidServiceTypeArray
            }
            pickerVC?.selectedString = self.serviceTypeView.text!
     
//            if sender.tag == 111 {
//                pickerVC?.selectedString = self.selectedBeneficiaryServiceTypeTxt.text!
//            }else{
//            }
            
            pickerVC?.titleString = "Service Type"
            pickerVC?.completionBlock = { string in
                self.serviceTypeView.text = string
//                if sender.tag == 111 {
//                    self.selectedBeneficiaryServiceTypeTxt.text = string
//                }else{
//                    self.serviceTypeView.text = string
//                }
            }
            let nav = UINavigationController(rootViewController: pickerVC!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    
}
/*
extension PhoneBillBeneficiaryViewController:PekoSegmentControlDelegate{
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
