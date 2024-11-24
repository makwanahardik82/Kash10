//
//  LogisticsReceiverDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/09/23.
//

import UIKit
import KMPlaceholderTextView

import PhoneCountryCodePicker

class LogisticsReceiverDetailViewController: MainViewController {

    
    @IBOutlet weak var receiverTableView: UITableView!
    
    @IBOutlet var headerView: UIView!
   
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var savedAddressView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var receiverNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var counrtyView: PekoFloatingTextFieldView!
    @IBOutlet weak var cityView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var buildIngNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var emailName: PekoFloatingTextFieldView!
    @IBOutlet weak var mobileNumberView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var addressLine1View: PekoFloatingTextFieldView!
    @IBOutlet weak var addressLine2View: PekoFloatingTextFieldView!
   
    @IBOutlet weak var savedAddressCheckButton: UIButton!
    // @IBOutlet weak var savedAddressCheckButton:UIButton
    
    var reciverAddreesArray = [AddressModel]()
    var countryArray = [LogisticsCountryModel]()
    var cityArray = [String]()
    var selectedCountryCode = ""
    
    static func storyboardInstance() -> LogisticsReceiverDetailViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsReceiverDetailViewController") as? LogisticsReceiverDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Logistics")
        self.view.backgroundColor = .white
        
        self.receiverTableView.tableHeaderView = self.headerView
        self.receiverTableView.tableFooterView = self.footerView
        self.receiverTableView.backgroundColor = .clear
        self.receiverTableView.separatorStyle = .none
        
     //   self.receiverTableView.delegate = self
//        self.receiverTableView.dataSource = self
//        self.receiverTableView.register(UINib(nibName: "LogisticsAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "LogisticsAddressTableViewCell")
//
        self.receiverTableView.backgroundColor = .clear
        self.receiverTableView.separatorStyle = .none
        
        self.savedAddressView.delegate = self
        self.counrtyView.delegate = self
        self.cityView.delegate = self
        
        
        self.getSavedAddress()
    }
    
    // MARK: - Saved Address
    @IBAction func saveAddressButtonClick(_ sender: Any) {
 /*
        if self.savedArray.count != 0 {
            
            let nameArray = self.savedArray.compactMap({ $0.name })
            
            let pickerVC = PickerListViewController.storyboardInstance()
            pickerVC?.array = nameArray
            
            pickerVC?.selectedString = self.cityTxt.text!
            pickerVC?.titleString = "Sender Address"
            pickerVC?.completionBlock = { string in
            
                let index = nameArray.firstIndex(of: string)
                let address = self.savedArray[index ?? 0]
                self.savedAddressTxt.text = address.name
                self.companyNameTxt.text = address.name
                self.departmentNameTxt.text = address.department
                self.countryTxt.text = address.country
                self.selectedCountryCode = address.countryCode ?? ""
                self.cityTxt.text = address.city
                self.address1Txt.text = address.addressLine1
                self.address2Txt.text = address.addressLine2
                self.phoneTxt.text = address.phoneNumber
                self.emailTxt.text = address.email
                self.getCity()
            }
            let nav = UINavigationController(rootViewController: pickerVC!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            
        }else{
            self.showAlert(title: "", message: "No saved address")
        }
        */
    }
    
    // MARK: - Country
    @IBAction func countryButtonClick(_ sender: Any) {
        let vc = PCCPViewController() { countryDic in
            if let countryDic = countryDic as? [String:Any] {
                if let cntname = countryDic["country_en"] as? String{
                 //   self.countryTxt.text = cntname
                   // self.setStatesArray(country: cntname)
                }
                if let countryCode = countryDic["country_code"] as? String{
         //           self.selectedCountryCode = countryCode
                }
                self.getCity()
            }
        }
        vc?.tableView.tintColor = .black
        vc?.title = "Country"
        let naviVC = UINavigationController(rootViewController: vc!)
        naviVC.modalPresentationStyle = .fullScreen
        self.present(naviVC, animated: true, completion: nil)
    }
    
    // MARK: - City
    @IBAction func cityButtonClick(_ sender: Any) {
        let pickerVC = PickerListViewController.storyboardInstance()
  //      pickerVC?.array = self.cityArray
        
      //  pickerVC?.selectedString = self.cityTxt.text!
        pickerVC?.titleString = "City"
        pickerVC?.completionBlock = { string in
    //        self.cityTxt.text = string
        }
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    // MARK: - SUbmit Button Click
    @IBAction func submitButtonClick(_ sender: Any) {
        
        let request = LogisticsAddressDetailModel(name: self.receiverNameView.text, country: self.counrtyView.text, city: self.cityView.text, buldingName: self.buildIngNameView.text, email: self.emailName.text, mobileNumber: self.mobileNumberView.text, countryCode: self.selectedCountryCode, pinCode: "", addressLine1: self.addressLine1View.text)
        
        let validationResult = LogisticsValidation().ValidateAddress(request: request)
        
        if validationResult.success {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                objLogisticsManager?.receiverAddress = request
                
                if self.savedAddressCheckButton.isSelected {
                    self.saveSenderAddress()
                }else{
                    self.goToShipmentVC()
                }
            }
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    // MARK: - Saved Adddress Check
    @IBAction func savedAddressCheckButtonClick(_ sender: Any) {
        self.savedAddressCheckButton.isSelected = !self.savedAddressCheckButton.isSelected
    }
    // MARK: -
    func saveSenderAddress(){
        HPProgressHUD.show()
        LogisticsViewModel().addAddress(request: (objLogisticsManager?.receiverAddress)!, isReceiver: true) { response, error in
            
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true{
                DispatchQueue.main.async {
              //      print(response)
                    print(response?.data)
             //       self.savedArray.append((response?.data)!)
                    self.goToShipmentVC()
                }
            } else{
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
    func goToShipmentVC(){
        if let shipmentVC = LogisticsShipmentDetailViewController.storyboardInstance() {
            self.navigationController?.pushViewController(shipmentVC, animated: true)
        }
    }
   
    // MARK: -
    func getSavedAddress() {
        HPProgressHUD.show()
        LogisticsViewModel().getSavedAddress(isReceiver: true) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true{
                DispatchQueue.main.async {
              //      print(response)
                    print(response?.data)
                    self.reciverAddreesArray = response?.data?.addresses ?? [AddressModel]()
                }
            } else{
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
    
    // MARK: - Get City
    func getCity() {
        HPProgressHUD.show()
        
        LogisticsViewModel().getCityFromCountry(countryCode: self.selectedCountryCode) { response, error in
            
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                  //  print(response?.Cities)
                    self.cityArray = response?.data?.Cities ?? [String]()
                }
            } else{
//                var msg = ""
//                if response?.Notifications?.count != 0, let first = response?.Notifications?.first as? LogisticsCalculateErrorModel{
//                    msg = first.Message ?? ""
//                }
//                self.showAlert(title: "", message: msg)
            }
        }
    }
}
extension LogisticsReceiverDetailViewController:PekoFloatingTextFieldViewDelegate{
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        
        if textView == self.savedAddressView {
           
            if let vc = LogisticsAddressViewController.storyboardInstance() {
                vc.isReceiver = true
                vc.completionBlock = { address in
                    self.receiverNameView.text = address.name ?? ""
                    self.counrtyView.text = address.country ?? ""
                    self.selectedCountryCode = address.countryCode ?? ""
                    self.cityView.text = address.city ?? ""
                    self.buildIngNameView.text = address.addressLine1 ?? ""
                    self.emailName.text = address.email ?? ""
                    self.mobileNumberView.text = address.phoneNumber ?? ""
                    
                    self.addressLine1View.text = address.addressLine2
                 //   self.addressLine2View.text = address.addressLine2
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }else if textView == self.counrtyView {
            
            let vc = PCCPViewController() { countryDic in
                
                if let countryDic = countryDic as? [String:Any] {
                    if let cntname = countryDic["country_en"] as? String{
                        self.counrtyView.text = cntname
                       // self.setStatesArray(country: cntname)
                    }
                    if let cntname = countryDic["country_code"] as? String{
                        self.selectedCountryCode = cntname
                       // self.setStatesArray(country: cntname)
                    }
                    self.getCity()
                }
            }
            vc?.tableView.tintColor = .black
            let naviVC = UINavigationController(rootViewController: vc!)
            naviVC.modalPresentationStyle = .fullScreen
            self.present(naviVC, animated: true, completion: nil)
          
        }else if textView == self.cityView {
            if self.cityArray.count != 0 {
                let pickerVC = PickerListViewController.storyboardInstance()
                pickerVC?.array = self.cityArray
                
                pickerVC?.selectedString = self.cityView.text!
                pickerVC?.titleString = "City"
                pickerVC?.completionBlock = { string in
                    self.cityView.text = string
                }
                let nav = UINavigationController(rootViewController: pickerVC!)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }else{
                self.showAlert(title: "", message: "No city found")
            }
            
        }
    }
    
    
}
