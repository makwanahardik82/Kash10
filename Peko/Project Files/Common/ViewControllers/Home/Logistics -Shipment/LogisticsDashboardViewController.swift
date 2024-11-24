//
//  LogisticsDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 29/08/23.
//

import UIKit
import KMPlaceholderTextView

import PhoneCountryCodePicker

class LogisticsDashboardViewController: MainViewController {

    
    @IBOutlet weak var logisticsTableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var savedAddressCheckButton: UIButton!
    @IBOutlet weak var savedAddressView: PekoFloatingTextFieldView!
    @IBOutlet weak var senderNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var countryView: PekoFloatingTextFieldView!
    @IBOutlet weak var cityView: PekoFloatingTextFieldView!
    @IBOutlet weak var buldingNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var emailView: PekoFloatingTextFieldView!
    @IBOutlet weak var mobileNumberView: PekoFloatingTextFieldView!
   
    @IBOutlet weak var addressLine1View: PekoFloatingTextFieldView!
    @IBOutlet weak var addressLine2View: PekoFloatingTextFieldView!
   
    @IBOutlet weak var domesticButton: UIButton!
    @IBOutlet weak var internationalButton: UIButton!
    
    
    var selectedCountryCode:String = ""
    var savedArray = [AddressModel]()
    var cityArray = [String]()
    var countryArray = [LogisticsCountryModel]()
    
    static func storyboardInstance() -> LogisticsDashboardViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsDashboardViewController") as? LogisticsDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Logistics")
        
        self.logisticsTableView.tableHeaderView = self.headerView
        self.logisticsTableView.tableFooterView = self.footerView
        self.logisticsTableView.backgroundColor = .clear
        self.logisticsTableView.separatorStyle = .none
        
        self.logisticsTableView.delegate = self
        self.logisticsTableView.dataSource = self
        self.logisticsTableView.register(UINib(nibName: "LogisticsAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "LogisticsAddressTableViewCell")
        self.logisticsTableView.backgroundColor = .clear
        self.logisticsTableView.separatorStyle = .none
        
        objLogisticsManager = LogisticsManager.sharedInstance
        
        self.savedAddressView.delegate = self
        self.countryView.delegate = self
        self.cityView.delegate = self
       
        self.backNavigationView?.orderHistoryView.isHidden = false
        self.backNavigationView?.historyButton.addTarget(self, action: #selector(bookingHistoryButtonClick), for: .touchUpInside)
       
        // Do any additional setup after loading the view.
    }
   // MARK: - Booking History Button
    @objc func bookingHistoryButtonClick(){
        if let historyVC = LogisticsHistoryViewController.storyboardInstance(){
            self.navigationController?.pushViewController(historyVC, animated: true)
        }
    }
    // MARK: - Radio
    @IBAction func domesticButtonClick(_ sender: Any) {
        self.domesticButton.isSelected = true
        self.internationalButton.isSelected = false
    }
    
    @IBAction func internationalButtonClick(_ sender: Any) {
        self.domesticButton.isSelected = false
        self.internationalButton.isSelected = true
    }
    
    // MARK: - SUbmit Button Click
    @IBAction func submitButtonClick(_ sender: Any) {
        
        let request = LogisticsAddressDetailModel(name: self.senderNameView.text!, country: self.countryView.text, city: self.cityView.text, buldingName: self.buldingNameView.text, email: self.emailView.text, mobileNumber: self.mobileNumberView.text, countryCode: self.selectedCountryCode, pinCode: "", addressLine1: self.addressLine1View.text)
      
        let validationResult = LogisticsValidation().ValidateAddress(request: request)

        if validationResult.success {
            self.view.endEditing(true)
            objLogisticsManager?.senderAddress = request
            if self.savedAddressCheckButton.isSelected {
                self.saveSenderAddress()
            }else{
                self.goToReciverVC()
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
        LogisticsViewModel().addAddress(request: (objLogisticsManager?.senderAddress)!, isReceiver: false) { response, error in
            
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
                 //   print(response?.data)
            //        self.savedArray.append((response?.data)!)
                    self.goToReciverVC()
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
    func goToReciverVC(){
        if let shipmentDetailVC = LogisticsReceiverDetailViewController.storyboardInstance() {
            self.navigationController?.pushViewController(shipmentDetailVC, animated: true)
        }
    }
   
    // MARK: -
  
    // MARK: - Get Country
    func getCountry() {
      
       // HPProgressHUD.show()
        LogisticsViewModel().getAllCountry(){ response, error in
       //     HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                   // print(response?.Cities)
                    self.countryArray = response?.data?.countries ?? [LogisticsCountryModel]()
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
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

}

// MARK: -
extension LogisticsDashboardViewController:UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 125
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogisticsAddressTableViewCell") as! LogisticsAddressTableViewCell
        cell.selectionStyle = .none
        
        
        return cell
    }
}
extension LogisticsDashboardViewController:PekoFloatingTextFieldViewDelegate{
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        
        if textView == self.savedAddressView {
           
            if let vc = LogisticsAddressViewController.storyboardInstance() {
                
                vc.isReceiver = false
                vc.completionBlock = { address in
                    self.senderNameView.text = address.name ?? ""
                    self.countryView.text = address.country ?? ""
                    self.selectedCountryCode = address.countryCode ?? ""
                    self.cityView.text = address.city ?? ""
                    self.buldingNameView.text = address.addressLine1 ?? ""
                    self.emailView.text = address.email ?? ""
                    self.mobileNumberView.text = address.phoneNumber ?? ""
                    
                    self.addressLine1View.text = address.addressLine2
                  //  self.addressLine2View.text = address.addressLine2
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            /*
            if self.savedArray.count != 0 {
                
                let nameArray = self.savedArray.compactMap({ $0.name })
                
                let pickerVC = PickerListViewController.storyboardInstance()
                pickerVC?.array = nameArray
           //     pickerVC?.selectedString = self.cityTxt.text!
                pickerVC?.titleString = "Sender Address"
                pickerVC?.completionIndexBlock = { index in
                  //  let index = nameArray.firstIndex(of: string)
                    let address = self.savedArray[index]
                }
                let nav = UINavigationController(rootViewController: pickerVC!)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
                
            }else{
                self.showAlert(title: "", message: "No saved address")
            }
            */
        }else if textView == self.countryView {
            
            let vc = PCCPViewController() { countryDic in
                
                if let countryDic = countryDic as? [String:Any] {
                    if let cntname = countryDic["country_en"] as? String{
                        self.countryView.text = cntname
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
            
            /*
            if self.countryArray.count != 0 {
                
                let nameArray = self.countryArray.compactMap({ $0.name })
                
                let pickerVC = PickerListViewController.storyboardInstance()
                pickerVC?.array = nameArray
                pickerVC?.selectedString = self.countryView.text!
                pickerVC?.titleString = "Country"
                pickerVC?.completionIndexBlock = { index in
                   // let index = nameArray.firstIndex(of: string)
                    let address = self.countryArray[index]
                    self.countryView.text = address.name ?? ""
                    self.selectedCountryCode = address.alpha2Code ?? ""
                    self.getCity()
                }
                let nav = UINavigationController(rootViewController: pickerVC!)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
                
            }else{
                self.showAlert(title: "", message: "No country found")
            }
            */
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
/*
extension LogisticsDashboardViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        
        if string == " " {
            return false
        }
        if textField == self.phoneTxt {
            return textField.numberValidation(number: string)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
*/
// MARK: -
//extension LogisticsDashboardViewController:PekoSegmentControlDelegate{
//    func selectedSegmentIndex(index: Int) {
//        self.scrollView.setContentOffset(CGPoint(x: Int(screenWidth) * (index - 1), y: 0), animated:true)
//    }
//}
