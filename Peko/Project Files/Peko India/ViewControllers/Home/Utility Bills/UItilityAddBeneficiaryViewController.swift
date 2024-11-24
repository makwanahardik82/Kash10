//
//  UItilityAddBeneficiaryViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 27/12/23.
//

import UIKit


class UItilityAddBeneficiaryViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var nameView: PekoFloatingTextFieldView!
    @IBOutlet weak var stateView: PekoFloatingTextFieldView!
    @IBOutlet weak var serviceProviderView: PekoFloatingTextFieldView!
    @IBOutlet weak var consumerNumberView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var resendOtpButton: UIButton!
    @IBOutlet weak var otpView: PekoOTPView!
    @IBOutlet weak var otpContainerView: UIView!
   
    @IBOutlet weak var titleLabel: PekoLabel!
    
    @IBOutlet weak var addButton: PekoButton!
    
    var beneficiaryModel:BeneficiaryDataModel?
    
    var isUpdateBeneficiary = false
    var timer:Timer?
    var totalSecond = 61
    
    var completionBlock:((_ beneficiary: BeneficiaryDataModel, _ sucess:Bool) -> Void)?
   
    var BBPS_BillersArray = [BBPS_BillersModel]()
    var selectedBBPS_Billers:BBPS_BillersModel?
    var bID = ""
    var paramName = ""
    
    static func storyboardInstance() -> UItilityAddBeneficiaryViewController? {
        return AppStoryboards.Utility.instantiateViewController(identifier: "UItilityAddBeneficiaryViewController") as? UItilityAddBeneficiaryViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = AppColors.blackThemeColor?.withAlphaComponent(0.8)
        self.bottomConstraint.constant = -450
        
        if self.isUpdateBeneficiary {
            self.titleLabel.text = "TITLE_UPDATE_BENEFICIARY_DETAILS".localizeString()
            
            self.nameView.text = self.beneficiaryModel?.name
            self.stateView.text = self.beneficiaryModel?.providerCircle ?? ""
            self.serviceProviderView.text = self.beneficiaryModel?.serviceProvider
            self.consumerNumberView.text = self.beneficiaryModel?.customerParams?.value.first?.value ?? ""
            self.bID = self.beneficiaryModel?.billerId ?? ""
           
            if  self.beneficiaryModel?.customerParams?.value.count != 0, let param =  self.beneficiaryModel?.customerParams?.value.first {
                self.paramName = param.paramName ?? ""
            }
            
            self.consumerNumberView.isHidden = false
          
        }else{
            self.titleLabel.text = "TITLE_ADD_BENEFICIARY_DETAILS".localizeString()
            self.stateView.isHidden = true
            self.consumerNumberView.isHidden = true
          
        }
        self.stateView.isHidden = true
        self.otpContainerView.isHidden = true
        
        self.BBPS_BillersArray = objUtilityBillsManager!.all_BBPS_BillersArray
        
        switch objUtilityBillsManager!.selectedUtilityBillType {
        case .Electricity: // Electricity
            self.stateView.isHidden = false
            self.serviceProviderView.isHidden = true
            break
        case .Broadband: // Broadband
           // self.stateView.isHidden = true
            self.consumerNumberView.placeholder = "Customer ID"
            break
        case .LPGCylinder: // LPG
            
            break
        case .PipedGas: //
  
            break
        case .Water: // WATER
          
            break
        case .EducationFee: // EDUCATION
            
            self.stateView.isHidden = true
            
            self.serviceProviderView.placeholder = "Institute"
            self.consumerNumberView.placeholder = "Student ID/Enrollment Number"
            
            break
        case .Landline:
          
            break
        case .none:
            break
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        self.animation()
    }
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
    // MARK: - Close Button Click
    @IBAction func closeButtonClick(_ sender: Any) {
//        if self.completionBlock != nil {
//            self.completionBlock!(nil, false)
//        }
        self.dismiss(animated: false)
    }
    
    // MARK: - State
    @IBAction func stateButtonClick(_ sender: Any) {
        let pickerVC = PickerListWithImageViewController.storyboardInstance()
        pickerVC?.titleArray = Constants.statesOfIndiaArray
        pickerVC?.selectedString = self.stateView.text ?? ""
        pickerVC?.titleString = "State"
        pickerVC?.completionBlock = { string in
            self.stateView.text = string
            self.serviceProviderView.isHidden = false
            self.getBBPS_BillersList()
          //  self.getBBPS_BillersList()
        }
        self.present(pickerVC!, animated: true)
    }
    // MARK: - Service Provider
    @IBAction func serviceProviderButtonClick(_ sender: Any) {
   
        let nameArray = self.BBPS_BillersArray.compactMap { $0.name }
        
        
        let pickerVC = PickerListWithImageViewController.storyboardInstance()
        pickerVC?.titleString = self.serviceProviderView.placeholder
        pickerVC?.selectedString = self.serviceProviderView.text ?? ""
        pickerVC?.titleArray = nameArray
        
        pickerVC?.completionIndexBlock = { index in
            let strTitle = nameArray[index]
          //  self.BBPS_Billers_ID = self.BBPS_BillersArray[index].id ?? ""
            self.selectedBBPS_Billers = self.BBPS_BillersArray[index]
            self.serviceProviderView.text = strTitle
            self.consumerNumberView.isHidden = false
            
            
            self.bID = self.selectedBBPS_Billers?.id ?? ""
            self.paramName = ""
            if  self.selectedBBPS_Billers?.customerParams?.count != 0, let param =  self.selectedBBPS_Billers?.customerParams?.first {
                self.paramName = param.paramName ?? ""
            }
            
        }
        self.present(pickerVC!, animated: true)
    }
    
    
    // MARK: - ADd Button
    @IBAction func addButtonClick(_ sender: Any) {
        
        let request = UtilityAddBeneficiaryRequest(name: self.nameView.text, state: self.stateView.text, serviceProvider: self.serviceProviderView.text, consumerNumber: self.consumerNumberView.text)
      
        let validationResult = UtilityAddBeneficiaryValidation().Validate(request: request)
        
        if validationResult.success {
            if self.addButton.tag == 1 {
                self.sendOTP()
            }else{
                if self.otpView.otpString.count != 6 {
                    self.showAlert(title: "", message: "Please enter OTP")
                }else{
                    if self.isUpdateBeneficiary {
                        self.updateBeneficiary(request: request)
                    }else{
                        self.addBeneficiary(request: request)
                    }
                }
            }
        }else{
            self.showAlert(title: "", message: validationResult.error ?? "")
        }
    }
    
    // MARK: - Resend Button Click
    @IBAction func resendButtonClick(_ sender: Any) {
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
                        self.addButton.setTitle("Update".localizeString(), for: .normal)
                       
                    }else{
                        self.addButton.setTitle("Add".localizeString(), for: .normal)
                    }
                    self.addButton.tag = 2
                    
                    self.totalSecond = 61
                    self.updateResendLabel()
                    self.startTimer()
                    self.resendOtpButton.isUserInteractionEnabled = false
                    self.otpContainerView.isHidden = false
                    self.otpView.textfield.becomeFirstResponder()
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
    // MARK: - Add Beneficiary
    func addBeneficiary(request:UtilityAddBeneficiaryRequest){
       
       
        UtilityBillsViewModel().addBeneficiary(request: request, billerID: bID, paramName: paramName, otpString: self.otpView.otpString) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if response?.status ?? false {
                DispatchQueue.main.async {
                    if self.completionBlock != nil {
                        self.completionBlock!((response?.data)!, true)
                    }
                    self.dismiss(animated: false)
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
    // MARK: - Update Beneficiary
    func updateBeneficiary(request:UtilityAddBeneficiaryRequest){
      
        HPProgressHUD.show()
        UtilityBillsViewModel().updateBeneficiary(b_id: self.beneficiaryModel?.id ?? 0, request: request, billerID: bID, paramName: paramName, otpString: self.otpView.otpString) { response in
            HPProgressHUD.hide()
            /*
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else
            */
            if response.status ?? false {
                DispatchQueue.main.async {
                    if self.completionBlock != nil {
                        self.beneficiaryModel?.name = self.nameView.text
                        self.beneficiaryModel?.serviceProvider = self.serviceProviderView.text
                        self.beneficiaryModel?.phoneNo = self.consumerNumberView.text
                        self.beneficiaryModel?.billerId = self.bID
                        self.completionBlock!(self.beneficiaryModel!, true)
                    }
                    self.dismiss(animated: false)
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
   
    
    // MARK: - Start Timer
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
      
        self.resendOtpButton.setTitle(self.totalSecond.timeString(), for: .normal)
        
        if totalSecond == 0 {
            self.invalidateTimer()
            self.resendOtpButton.setTitle("Resend", for: .normal)
            self.resendOtpButton.isUserInteractionEnabled = true
            totalSecond = 61
        }
    }
    
    // MARK: -
    func getBBPS_BillersList(){
        HPProgressHUD.show()
        UtilityBillsViewModel().getBBPS_BillersList(categoryName: "Electricity", state: self.stateView.text!) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response?.data)
                    objUtilityBillsManager!.all_BBPS_BillersArray = response?.data ?? [BBPS_BillersModel]()
                    self.BBPS_BillersArray = objUtilityBillsManager!.all_BBPS_BillersArray
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }
                self.showAlert(title: "", message: msg)
                HPProgressHUD.hide()
            }
        }
    }
}
