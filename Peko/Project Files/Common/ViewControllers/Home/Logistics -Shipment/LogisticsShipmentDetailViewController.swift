//
//  LogisticsShipmentDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/09/23.
//

import UIKit


enum ShipmentType : Int
{
    case document, parcel
}


class LogisticsShipmentDetailViewController: MainViewController {

    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var contentView: PekoFloatingTextFieldView!
    @IBOutlet weak var noOfPiecesView: PekoFloatingTextFieldView!
    @IBOutlet weak var totalWeightView: PekoFloatingTextFieldView!
    @IBOutlet weak var shedulePickupView: PekoFloatingTextFieldView!
    @IBOutlet weak var serviceTypeView: PekoFloatingTextFieldView!
    
    var serviceTypeCode = ""
    var serviceTypeName = ""
    
    
    //    @IBOutlet weak var documentButton: UIButton!
//    @IBOutlet weak var parcelButton: UIButton!
//    
//    @IBOutlet weak var originOfGoodTxt: UITextField!
//    @IBOutlet weak var goodOriginTxt: UITextField!
//    
//    
//    @IBOutlet weak var noOfPiecesTxt: UITextField!
//    @IBOutlet weak var lengthTxt: UITextField!
//    @IBOutlet weak var widthTxt: UITextField!
//    @IBOutlet weak var heightTxt: UITextField!
//    @IBOutlet weak var kiloGramTxt: UITextField!
//    
//    @IBOutlet weak var amountTxt: UITextField!
//    
  //  var shipmentType:ShipmentType = .document
    
    static func storyboardInstance() -> LogisticsShipmentDetailViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsShipmentDetailViewController") as? LogisticsShipmentDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Logistics")
        self.view.backgroundColor = .white
        
        self.detailTableView.backgroundColor = .clear
        self.detailTableView.tableHeaderView = self.headerView
        
        self.contentView.delegate = self
        self.serviceTypeView.delegate = self
        shedulePickupView.delegate = self
        shedulePickupView.minimumDate = Date()
    }
    
    // MARK: - SUbmit Button Click
    @IBAction func submitButtonClick(_ sender: Any) {
        
        objLogisticsManager?.serviceTypeName = self.serviceTypeName
      //  objLogisticsManager?.shipmentServiceModel.serviceTypeCode = self.serviceTypeCode
        
        let request = LogisticsShipmentDetailModel(content: self.contentView.text, noOfPieces: self.noOfPiecesView.text, weight: self.totalWeightView.text, sheduleDate: self.shedulePickupView.selectedDate, serviceType: self.serviceTypeView.text)
        
        let validationResult = LogisticsValidation().ValidateAddress(request: request)
        
        if validationResult.success {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                
                objLogisticsManager?.shipmentDetailModel = request
             
                self.calculateRate()
            }
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    func calculateRate(){
        HPProgressHUD.show()
        LogisticsViewModel().calculateRate { response, error in
            
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                  //  print(response?.data)
                  //  self.savedArray.append((response?.data)!)
                    objLogisticsManager?.calculateRateResponseModel = response?.data
                    if let reviewVC = LogisticsConfirmShipmentViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(reviewVC, animated: true)
                    }
                }
            } else{
                var msg = ""
                if response?.message?.count != nil {
                    msg = response?.message ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
}
extension LogisticsShipmentDetailViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        if textView == self.contentView {
            let pickerVC = PickerListViewController.storyboardInstance()
            pickerVC?.array = ["Document", "Parcel"]
            
            pickerVC?.selectedString = self.contentView.text!
            pickerVC?.titleString = "What is your shipment content?"
            pickerVC?.completionBlock = { string in
                self.contentView.text = string
            }
            let nav = UINavigationController(rootViewController: pickerVC!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }else if textView == self.serviceTypeView {
            var array = [Dictionary<String, Any>]()
            
            if (objLogisticsManager?.senderAddress?.countryCode ?? "") == (objLogisticsManager?.receiverAddress?.countryCode ?? "") {
                
                if self.contentView.text == "Document" {
                    array = Constants.logisticsDomesticDocumentServiceType
                }else{
                    array = Constants.logisticsDomesticParcelServiceType
                }
                
            }else{
                if self.contentView.text == "Document" {
                    array = Constants.logisticsIntenationalDocumentServiceType
                }else{
                    array = Constants.logisticsIntenationalParcelServiceType
                }
            }
            
            let titleArray = array.compactMap({ $0["name"] }) as! [String]
            
            let pickerVC = PickerListViewController.storyboardInstance()
            pickerVC?.array = titleArray
            pickerVC?.selectedString = self.serviceTypeView.text!
            pickerVC?.titleString = "Service Type"
            pickerVC?.completionBlock = { string in
                self.serviceTypeView.text = string
                
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
        }
    }
}
