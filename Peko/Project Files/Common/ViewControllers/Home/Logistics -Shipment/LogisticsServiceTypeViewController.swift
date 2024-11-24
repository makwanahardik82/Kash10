//
//  LogisticsServiceTypeViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/09/23.
//

import UIKit


class LogisticsServiceTypeViewController: MainViewController {

    @IBOutlet weak var serviceTypeTxt: UITextField!
    
    @IBOutlet weak var shieldCheckButton: UIButton!
    @IBOutlet weak var cashOnDeliveryCheckButton: UIButton!
    
    @IBOutlet weak var sheildAmountTxt: UITextField!
    
    @IBOutlet weak var cashOnAmountTxt: UITextField!
    
    var serviceTypeCode = ""
    var serviceTypeName = ""
    
    static func storyboardInstance() -> LogisticsServiceTypeViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsServiceTypeViewController") as? LogisticsServiceTypeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Logistics")
     
       
      
        // Do any additional setup after loading the view.
    }
   
    // MARK: - Service Type
    @IBAction func serviceTypeButtonCLick(_ sender: Any) {
       /*
        var array = [Dictionary<String, Any>]()
        
        if objLogisticsManager?.senderAddress?.countryCode == objLogisticsManager?.receiverAddress?.countryCode {
            
            if objLogisticsManager?.shipmentType == .document {
                array = CommonConstants.logisticsDomesticDocumentServiceType
            }else{
                array = CommonConstants.logisticsDomesticParcelServiceType
            }
            
        }else{
            if objLogisticsManager?.shipmentType == .document {
                array = CommonConstants.logisticsIntenationalDocumentServiceType
            }else{
                array = CommonConstants.logisticsIntenationalParcelServiceType
            }
        }
        
        let titleArray = array.compactMap({ $0["name"] }) as! [String]
        
        let pickerVC = PickerListViewController.storyboardInstance()
        pickerVC?.array = titleArray
        pickerVC?.selectedString = self.serviceTypeTxt.text!
        pickerVC?.titleString = "Service Type"
        pickerVC?.completionBlock = { string in
            self.serviceTypeTxt.text = string
            
            let index = titleArray.firstIndex(of: string)
            let dic = array[index ?? 0]
            
            if let code = dic["code"] as? String {
                self.serviceTypeCode = code
            }
            if let name = dic["name"] as? String {
                self.serviceTypeName = name
            }
        }
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        */
    }
    
    @IBAction func shieldCheckButtonClick(_ sender: Any) {
        self.shieldCheckButton.isSelected = !self.shieldCheckButton.isSelected
    }
    
    // MARK: - Cash On Delivery
    @IBAction func cashOnDeliveryButtonClick(_ sender: Any) {
        self.cashOnDeliveryCheckButton.isSelected = !self.cashOnDeliveryCheckButton.isSelected
    }
    
    // MARK: - Submit
    @IBAction func submitButtonClick(_ sender: Any) {
       /*
        if self.serviceTypeTxt.text!.isEmpty {
            self.showAlert(title: "", message: "Please select service type")
            return
        }
        
        if self.serviceTypeTxt.text!.isEmpty {
            self.showAlert(title: "", message: "Please select service type")
            return
        }
        
        if self.shieldCheckButton.isSelected {
            if self.sheildAmountTxt.text!.isEmpty {
                self.showAlert(title: "", message: "Please enter sheild amount")
                return
            }
        }
        
        if self.cashOnDeliveryCheckButton.isSelected {
            if self.cashOnAmountTxt.text!.isEmpty {
                self.showAlert(title: "", message: "Please enter cash on delivery amount")
                return
            }
            objLogisticsManager?.shipmentServiceModel.cashOnDeliveryAmount = self.cashOnAmountTxt.text!
        }else{
            objLogisticsManager?.shipmentServiceModel.cashOnDeliveryAmount = ""
        }
        
        objLogisticsManager?.serviceTypeName = self.serviceTypeName
        objLogisticsManager?.shipmentServiceModel.serviceTypeCode = self.serviceTypeCode
        
        */
       
    }
 // MARK: -
    func goToConfirmView() {
        
        
        if let confirmVC = LogisticsConfirmShipmentViewController.storyboardInstance() {
            self.navigationController?.pushViewController(confirmVC, animated: true)
        }
    }
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
//    
}
