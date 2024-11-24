//
//  eSimDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/04/24.
//

import UIKit

class eSimDashboardViewController: MainViewController {

    @IBOutlet weak var eSimTypeView: PekoFloatingTextFieldView!
    @IBOutlet weak var eSimCountryView: PekoFloatingTextFieldView!
   
    var selectedValue = ""
    var selectedCountryCode = ""
    
    var typeArray = [
        [
            "title":"Local eSIM",
            "value":"local"
        ],
        [
            "title":"Regional eSIM",
            "value":"regional"
        ],
        [
            "title":"Global eSIM",
            "value":"regional"
        ]
    ]
    var packageArray = [ESimPackageModel]()

    static func storyboardInstance() -> eSimDashboardViewController? {
        return AppStoryboards.eSim.instantiateViewController(identifier: "eSimDashboardViewController") as? eSimDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "eSIM")
        self.view.backgroundColor = .white
      
        self.backNavigationView?.orderHistoryView.isHidden = false
        self.backNavigationView?.historyButton.addTarget(self, action: #selector(historyButtonClick), for: .touchUpInside)
       
        self.eSimTypeView.delegate = self
        self.eSimCountryView.delegate = self
        
        objeSIMManager = eSIMManager.sharedInstance
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Booking History Button
     @objc func historyButtonClick(){
         if let historyVC = eSimOrderHistoryViewController.storyboardInstance(){
             self.navigationController?.pushViewController(historyVC, animated: true)
         }
     }
// MARK: - Search Button
    @IBAction func searchButtonClick(_ sender: Any) {
        if self.eSimCountryView.text?.count == 0 {
            self.showAlert(title: "", message: "Please select country")
            return
        }
        
        let pkg = self.packageArray.filter { $0.country_code == self.selectedCountryCode }
        
        objeSIMManager?.selectedPackage = pkg.first
        
        if let resultVC = eSimSearchResultViewController.storyboardInstance() {
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    // MARK: -Compatible
    @IBAction func compatibleDeviceButtonClick(_ sender: Any) {
        if let supportedVC = eSimCompatibleDeviceViewController.storyboardInstance() {
            self.navigationController?.pushViewController(supportedVC, animated: true)
        }
    }
    // MARK: -
    @IBAction func howWorksButtonClick(_ sender: Any) {
        if let supportedVC = eSimHowToWorkViewController.storyboardInstance() {
            self.navigationController?.pushViewController(supportedVC, animated: true)
        }
    }
    
    // MARK: -
    func getPackage(){
        HPProgressHUD.show()
        eSimViewModel().getPackages(type: self.selectedValue, countryCode: self.selectedCountryCode) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response?.data?.packages)
                    self.packageArray = response?.data?.packages ?? [ESimPackageModel]()
                   // objeSIMManager?.usdToAed = response?.data?.usdToAed?.value ?? 0.0
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
// MARK: - PekoFloatingTextFieldViewDelegate
extension eSimDashboardViewController:PekoFloatingTextFieldViewDelegate{
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        if textView == self.eSimTypeView{
            
            let titleArray = self.typeArray.compactMap { $0["title"] }
            let valueArray = self.typeArray.compactMap { $0["value"] }
            
            if let catVC = PickerListViewController.storyboardInstance() {
                catVC.array = titleArray
                catVC.selectedString = self.eSimTypeView.text!
                catVC.titleString = "eSIM Type"
                catVC.completionIndexBlock = { index in
                    self.selectedValue = valueArray[index]
                    self.eSimTypeView.text! = titleArray[index]
                    self.getPackage()
                }
                let nav = UINavigationController(rootViewController: catVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }else if textView == self.eSimCountryView {
            
            if self.eSimTypeView.text?.count == 0 {
                self.showAlert(title: "", message: "Please select eSIM type")
                return
            }
            
            let titleArray = self.packageArray.compactMap { $0.title }
            let valueArray = self.packageArray.compactMap { $0.country_code }
           
            if let catVC = PickerListViewController.storyboardInstance() {
                catVC.array = titleArray
                catVC.selectedString = self.eSimTypeView.text!
                catVC.titleString = "Country"
                catVC.completionIndexBlock = { index in
                    
                    if valueArray.count != 0 && titleArray.count != 0 {
                        self.selectedCountryCode = valueArray[index]
                        self.eSimCountryView.text! = titleArray[index]
                    }
                    
                }
                let nav = UINavigationController(rootViewController: catVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    
}
