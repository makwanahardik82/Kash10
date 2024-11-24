//
//  ElectricityFetchBillViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 13/12/23.
//

import UIKit


class UtilityFetchBillViewController: MainViewController {

    @IBOutlet weak var stateView: PekoFloatingTextFieldView!
    @IBOutlet weak var serviceProviderView: PekoFloatingTextFieldView!
    @IBOutlet weak var numberView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var dropDownView: PekoFloatingTextFieldView!
    @IBOutlet weak var validationLabel: PekoLabel!
    var screenTitle:String = ""
    var stateName:String = ""
    
    static func storyboardInstance() -> UtilityFetchBillViewController? {
        return AppStoryboards.Utility.instantiateViewController(identifier: "UtilityFetchBillViewController") as? UtilityFetchBillViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: screenTitle)
        self.view.backgroundColor = .white
        self.dropDownView.isHidden = true
        self.backNavigationView?.bharatBillPayImgView.isHidden = false

        switch objUtilityBillsManager!.selectedUtilityBillType {
        case .Electricity: // Electricity
            self.stateView.isHidden = false
            self.serviceProviderView.isHidden = false
            self.numberView.isHidden = false
            self.validationLabel.isHidden = false
            break
        case .Broadband: // Broadband
            self.stateView.isHidden = true
            self.serviceProviderView.isHidden = false
            self.numberView.isHidden = false
            self.numberView.placeholder = "Customer ID"
            self.validationLabel.isHidden = false
            break
        case .LPGCylinder: // LPG
            self.stateView.isHidden = true
            self.serviceProviderView.isHidden = false
            self.numberView.isHidden = false
            self.validationLabel.isHidden = true
            self.dropDownView.isHidden = false
            break
        case .PipedGas: //
            self.stateView.isHidden = true
            self.serviceProviderView.isHidden = false
            self.numberView.isHidden = false
            break
        case .Water: // WATER
            self.stateView.isHidden = false
            self.serviceProviderView.isHidden = false
            self.numberView.isHidden = false
            self.validationLabel.isHidden = false
            break
        case .EducationFee: // EDUCATION
            
            self.stateView.isHidden = true
            self.serviceProviderView.isHidden = false
            self.numberView.isHidden = false
            self.validationLabel.isHidden = true
            self.dropDownView.isHidden = true
            
            self.serviceProviderView.placeholder = "Institute"
            self.numberView.placeholder = "Student ID/Enrollment Number"
            
            break
        case .Landline:
            self.stateView.isHidden = false
            self.serviceProviderView.isHidden = false
            self.numberView.isHidden = false
            break
        case .none:
            break
        }
        
        self.stateView.text = self.stateName
        self.serviceProviderView.text = objUtilityBillsManager!.serviceProvideName
        self.serviceProviderView.leftImage = nil
        self.numberView.text = objUtilityBillsManager?.consumerNumber ?? ""
        objPaymentManager = PaymentManager.sharedInstance
    
        // Do any additional setup after loading the view.
    }
   
    // MARK: - Fetch Bill
    @IBAction func fetchBillButtonClick(_ sender: Any) {
        
        self.fetchBillDetails()
        
    }
    
    // MARK: - Fetch
    func fetchBillDetails() {
        if self.numberView.text?.count == 0 {
            self.showAlert(title: "", message: "Please enter consumer number".localizeString())
            return
        }else{
            objUtilityBillsManager!.consumerNumber = self.numberView.text!
            
            HPProgressHUD.show()
            UtilityBillsViewModel().getUtilityBill { response, error in
                HPProgressHUD.hide()
               
                if error != nil {
                    #if DEBUG
                    self.showAlert(title: "", message: error?.localizedDescription ?? "")
    #else
                    self.showAlert(title: "", message: "Something went wrong please try again")
    #endif

                }else if let status = response?.status, status == true {
                    DispatchQueue.main.async {
                        objUtilityBillsManager!.billDataModel = response?.data?.data
                        self.goToPaymentView()
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
    // MARK: - Go to Payment
    func goToPaymentView(){
        if let payNowVC = PaymentPayNowViewController.storyboardInstance() {
            objPaymentManager!.reviewPaymentType = .UtilityBills
            
            let billDate = (objUtilityBillsManager!.billDataModel?.bill?.billDate ?? "").toDate(format: "YYYY-MM-dd")
            let dueDate = (objUtilityBillsManager!.billDataModel?.bill?.dueDate ?? "").toDate(format: "YYYY-MM-dd")
           
            let billDateString = billDate.formate(format: "MMM dd yyyy")
            let dueDateString = dueDate.formate(format: "MMM dd yyyy")
            
            objPaymentManager!.billSummaryArray = [
                [
                    "title":"Service Provider",
                    "detail":self.serviceProviderView.text!
                ],
                [
                    "title":"Consumer Number",
                    "detail":self.numberView.text!
                ],
                [
                    "title":"Bill Number",
                    "detail":(objUtilityBillsManager!.billDataModel?.bill?.billNumber?.value ?? "")
                ],
                [
                    "title":"Bill Date",
                    "detail":billDateString
                    
                ],
                [
                    "title":"Due Date",
                    "detail":dueDateString
                    
                ],
                [
                    "title":"Account Holder",
                    "detail":(objUtilityBillsManager!.billDataModel?.bill?.customerName ?? "")
                ]
            ]
            objPaymentManager!.screenTitle = self.getTitle()
            self.navigationController?.pushViewController(payNowVC, animated: true)
        }
    }
}
