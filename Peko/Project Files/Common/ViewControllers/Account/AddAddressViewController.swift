//
//  AddAddressViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 02/04/24.
//

import UIKit

class AddAddressViewController: MainViewController {
    @IBOutlet weak var fullNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var addressLine1View: PekoFloatingTextFieldView!
    @IBOutlet weak var addressLine2View: PekoFloatingTextFieldView!
    @IBOutlet weak var phoneNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var addressTypeView: PekoFloatingTextFieldView!
    @IBOutlet weak var zipView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var checkbuton: UIButton!
  
    var isEdit:Bool = false
    var addressModel:AddressModel?
    
    static func storyboardInstance() -> AddAddressViewController? {
        return AppStoryboards.Account.instantiateViewController(identifier: "AddAddressViewController") as? AddAddressViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
     
        self.addressTypeView.delegate = self
        
        if self.isEdit {
            self.fullNameView.text = self.addressModel?.name ?? ""
            self.addressLine1View.text = self.addressModel?.addressLine1 ?? ""
            self.addressLine2View.text = self.addressModel?.addressLine2 ?? ""
            self.phoneNumberView.text = self.addressModel?.phoneNumber ?? ""
            self.addressTypeView.text = self.addressModel?.addressType?.value ?? ""
            self.zipView.text = self.addressModel?.zipCode ?? ""
            self.checkbuton.isSelected = self.addressModel?.is_default?.value ?? false
            self.setTitle(title: "Update Address")
           
        }else{
            self.setTitle(title: "Add Address")
        }
        
    }
    @IBAction func checkButtonClick(_ sender: Any) {
        self.checkbuton.isSelected = !self.checkbuton.isSelected
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        
        var ids:Int = 0
        if self.isEdit {
            ids = self.addressModel?.id ?? 0
        }
        
        let request = AddressRequest(fullName: self.fullNameView.text!, addressLine1: self.addressLine1View.text!, addressLine2: self.addressLine2View.text!, phoneNumber: self.phoneNumberView.text!, zipCode: self.zipView.text!, addressType: self.addressTypeView.text!, isDefault: self.checkbuton.isSelected, id: ids)
        
        let validationResult = AddAddressValidation().Validate(request: request)
        
        if validationResult.success {
            self.addAddress(request: request)
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    func addAddress(request:AddressRequest){
        HPProgressHUD.show()
        
        ProfileViewModel().addAddreess(request: request) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response.status, status == true {
                DispatchQueue.main.async {
                    self.showAlertWithCompletion(title: "", message: (response.message ?? "").capitalized) { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                var msg = ""
                if response.message != nil {
                    msg = response.message
                    ?? ""
                }else if response.error?.count != nil {
                    msg = response.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
}
// MARK: -
extension AddAddressViewController:PekoFloatingTextFieldViewDelegate{
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        if textView == self.addressTypeView {
            if let pickerVC = PickerListViewController.storyboardInstance() {
                pickerVC.array = ["Home", "Office"]
                pickerVC.selectedString = self.addressTypeView.text!
                pickerVC.titleString = "Address Type"
                pickerVC.completionBlock = { string in
                    self.addressTypeView.text = string
                }
                let nav = UINavigationController(rootViewController: pickerVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    
}
