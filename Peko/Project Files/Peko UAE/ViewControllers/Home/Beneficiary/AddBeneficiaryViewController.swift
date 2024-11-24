//
//  AddBeneficiaryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 27/02/24.
//

import UIKit


enum BeneficiaryAddUpdate: Int {
    case PhoneBillAdd = 0
    case PhoneBillUpdate
    case PhoneBillDelete
    case UtilityBillAdd
    case UtilityBillUpdate
    case UtilityBillDelete
}

class AddBeneficiaryViewController: UIViewController {

    @IBOutlet weak var cancelButton: PekoButton!
    @IBOutlet weak var saveButton: PekoButton!
    
    @IBOutlet weak var nameView: PekoFloatingTextFieldView!
    @IBOutlet weak var numberView: PekoFloatingTextFieldView!
    @IBOutlet weak var otpView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
   
    var completionBlock:((_ selectedBeneficiary:BeneficiaryModel) -> Void)?
    var deleteCompletionBlock:((_ isDeleted:Bool) -> Void)?
    
    var action:BeneficiaryAddUpdate = .PhoneBillAdd
    var oldBeneficiaryModel:BeneficiaryModel?
    
    static func storyboardInstance() -> AddBeneficiaryViewController? {
        return AppStoryboards.Beneficiary.instantiateViewController(identifier: "AddBeneficiaryViewController") as? AddBeneficiaryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = AppColors.blackThemeColor?.withAlphaComponent(0.8)
       
        self.otpView.isHidden = true
        saveButton.tag = 100
        saveButton.setTitle("Send OTP", for: .normal)
        
        if self.action == .PhoneBillAdd || self.action == .PhoneBillUpdate {
            self.numberView.placeholder = "Phone Number"
            self.numberView.textFieldType = .Mobile
        }else{
            self.numberView.placeholder = "Account Number"
            self.numberView.textFieldType = .Number
        }
        
        if self.action == .PhoneBillUpdate || self.action == .UtilityBillUpdate {
            self.nameView.text = self.oldBeneficiaryModel?.name ?? ""
            self.numberView.text = self.oldBeneficiaryModel?.accountNo ?? ""
            self.titleLabel.text = "Edit Beneficiary Details"
        }else if self.action == .PhoneBillDelete || self.action == .UtilityBillDelete {
            self.nameView.text = self.oldBeneficiaryModel?.name ?? ""
            self.numberView.text = self.oldBeneficiaryModel?.accountNo ?? ""
            self.titleLabel.text = "Delete Beneficiary Details"
            
            let beneficiaryRequest = BeneficiaryRequest(name: self.oldBeneficiaryModel?.name, accountNo: self.oldBeneficiaryModel?.accountNo, accessKey: self.oldBeneficiaryModel?.accessKey)
           
            self.sendOTP(type: "DELETE", request: beneficiaryRequest)
        }
       else{
            self.titleLabel.text = "Add Beneficiary Details"
        }
        
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
    
// MARK: - Cancel Button Click
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    // MARK: - Save Button Click
    @IBAction func saveButtonClick(_ sender: Any) {
        if self.action == .PhoneBillDelete {
            self.deletePhoneBillBeneficiary()
        }else if self.action == .UtilityBillDelete {
            self.deleteUtilityBeneficiary()
        }else{
            var accessKey = ""
            if self.action == .PhoneBillAdd  || self.action == .PhoneBillUpdate {
                accessKey = objPhoneBillsManager?.limitDataModel?.accessKey ?? ""
            }else{
                accessKey = objUtilityPaymentManager?.limitDataModel?.accessKey ?? ""
            }
            
            let beneficiaryRequest = BeneficiaryRequest(name: self.nameView.text!, accountNo: self.numberView.text!, accessKey: accessKey)
            
            let validationResult = BeneficiaryValidation().Validate(beneficiaryRequest: beneficiaryRequest)
            self.view.endEditing(true)
            
            if validationResult.success {
                
                if saveButton.tag == 100 {
                    if self.action == .PhoneBillUpdate || self.action == .UtilityBillUpdate {
                        self.sendOTP(type: "EDIT", request: beneficiaryRequest)
                    }else{
                        self.sendOTP(type: "ADD", request: beneficiaryRequest)
                    }
                }else{
                    if self.otpView.text!.count != 6 {
                        self.showAlert(title: "", message: "Please enter OTP")
                    }else{
                        if self.action == .PhoneBillAdd  {
                            self.addPhoneBillBeneficiary(beneficiaryRequest: beneficiaryRequest)
                        }else if self.action == .PhoneBillUpdate {
                            var request:BeneficiaryModel = self.oldBeneficiaryModel!
                            request.name = self.nameView.text!
                            request.accountNo = self.numberView.text!
                            self.updatePhoneBillBeneficiary(request: request)
                        }else if self.action == .UtilityBillAdd  {
                            self.addUtilityBeneficiary(request: beneficiaryRequest)
                        }else if self.action == .UtilityBillUpdate {
                            var request:BeneficiaryModel = self.oldBeneficiaryModel!
                            request.name = self.nameView.text!
                            request.accountNo = self.numberView.text!
                            self.updateUtilityBeneficiary(request: request)
                        }
                    }
                }
            }else{
                self.showAlert(title: "", message: validationResult.error!)
            }
        }
    }
    
    // MARK: - Send OTP
    // MARK: - SEND OTP
    func sendOTP(type:String, request:BeneficiaryRequest){
        HPProgressHUD.show()
        OTPViewModel().generateOTPForBeneficiary(type: type, request: request) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if response?.status ?? false {
                DispatchQueue.main.async {
                    if self.action == .PhoneBillDelete || self.action == .UtilityBillDelete {
                        self.saveButton.setTitle("Delete", for: .normal)
                    }else{
                        self.saveButton.setTitle("Save", for: .normal)
                        
                    }
                    self.saveButton.tag = 200
                    self.otpView.isHidden = false
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
    
    // MARK: - Phone Bill
    // MARK: - Add Bill Beneficiary
    func addPhoneBillBeneficiary(beneficiaryRequest:BeneficiaryRequest){
        HPProgressHUD.show()
        PhoneBillBeneficiaryViewModel().addBeneficiary(request: beneficiaryRequest, otpString: self.otpView.text!) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    let selectedBeneficiary = response?.data! // ?.first
                    if self.completionBlock != nil {
                        self.completionBlock!(selectedBeneficiary!)
                        self.cancelButtonClick(self.cancelButton!)
                    }
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
    // MARK: -
    func updatePhoneBillBeneficiary(request:BeneficiaryModel){
        
        HPProgressHUD.show()
        PhoneBillBeneficiaryViewModel().updateBeneficiary(request: request, otpString: self.otpView.text!) {  response in
         
            HPProgressHUD.hide()
            if let status = response.status, status == true {
                DispatchQueue.main.async {
                    if self.completionBlock != nil {
                        self.completionBlock!(request)
                        self.cancelButtonClick(self.cancelButton!)
                    }
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
    func deletePhoneBillBeneficiary(){
        
        HPProgressHUD.show()
        PhoneBillBeneficiaryViewModel().deleteBeneficiary(beneficiary_id: "\(self.oldBeneficiaryModel?.id ?? 0)") {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    if self.deleteCompletionBlock != nil {
                        self.deleteCompletionBlock!(true)
                        self.cancelButtonClick(self.cancelButton!)
                    }
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
    // MARK: - Utility
    
    // MARK: - Update Beneficiary
    func updateUtilityBeneficiary(request:BeneficiaryModel){
        
        HPProgressHUD.show()
        UItilityBeneficiaryViewModel().updateBeneficiary(request: request, otpString: self.otpView.text!) { response in
            HPProgressHUD.hide()
            if let status = response.status, status == true {
                DispatchQueue.main.async {
                    if self.completionBlock != nil {
                        self.completionBlock!(request)
                        self.cancelButtonClick(self.cancelButton!)
                    }
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
    func addUtilityBeneficiary(request:BeneficiaryRequest){
        HPProgressHUD.show()
        UItilityBeneficiaryViewModel().addBeneficiary(request: request, otpString: self.otpView.text!) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    let selectedBeneficiary = response?.data! // ?.first
                    if self.completionBlock != nil {
                        self.completionBlock!(selectedBeneficiary!)
                        self.cancelButtonClick(self.cancelButton!)
                    }
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
    // MARK: -
    func deleteUtilityBeneficiary(){
        HPProgressHUD.show()
        UItilityBeneficiaryViewModel().deleteBeneficiary(beneficiary_id: "\(self.oldBeneficiaryModel?.id ?? 0)") {  response, error  in
            
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    if self.deleteCompletionBlock != nil {
                        self.deleteCompletionBlock!(true)
                        self.cancelButtonClick(self.cancelButton!)
                    }
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
