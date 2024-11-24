//
//  AirticketAddPassengerDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/03/24.
//

import UIKit
import PhoneCountryCodePicker

class AirticketAddPassengerDetailViewController: MainViewController {

    @IBOutlet weak var mrButton: PekoButton!
    @IBOutlet weak var msButton: PekoButton!
    @IBOutlet weak var mrsButton: PekoButton!
    
    @IBOutlet weak var firstNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var lastNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var dateOfBirthView: PekoFloatingTextFieldView!
   
    @IBOutlet weak var passportNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var passportIssueDateView: PekoFloatingTextFieldView!
    @IBOutlet weak var passportExpiryDateView: PekoFloatingTextFieldView!
    @IBOutlet weak var passportIssueCountryView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var nationalityView: PekoFloatingTextFieldView!
  
    var isEdit = false
    var passengerModel:AirTicketPassangerDetailsModel?
    
    var completionBlock:((_ model:AirTicketPassangerDetailsModel) -> Void)?
  
    static func storyboardInstance() -> AirticketAddPassengerDetailViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirticketAddPassengerDetailViewController") as? AirticketAddPassengerDetailViewController
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Passenger Details")
        self.view.backgroundColor = .white
   
        self.honorButtonClick(self.mrButton)
        
        
        self.dateOfBirthView.maximumDate = Date().addDays(day: -1)
        self.passportIssueDateView.maximumDate = Date().addDays(day: -1)
        self.passportExpiryDateView.minimumDate = Date() //.addDays(day: -1)
        
        self.passportIssueCountryView.delegate = self
        self.nationalityView.delegate = self
        
        if self.isEdit {
            if self.passengerModel!.honor ==  "Mr" {
                self.honorButtonClick(self.mrButton)
            }else if self.passengerModel!.honor == "Ms"{
                self.honorButtonClick(self.msButton)
                
            }else if self.passengerModel!.honor == "Mrs" {
                self.honorButtonClick(self.mrsButton)
            }
            self.firstNameView.text = self.passengerModel?.first_name ?? ""
            self.lastNameView.text! = self.passengerModel?.last_name ?? ""
            self.dateOfBirthView.selectedDate = self.passengerModel?.dateOfBirth ?? Date()
            self.passportNumberView.text! = self.passengerModel?.passportNumber ?? ""
            self.passportIssueDateView.selectedDate = self.passengerModel?.passportIssueDate ?? Date()
            self.passportExpiryDateView.selectedDate = self.passengerModel?.passportExpiryDate ?? Date()
            self.passportIssueCountryView.text! = self.passengerModel?.passportIssueCountry ?? ""
            nationalityView.text! = self.passengerModel?.nationality ?? ""
         
        }else{
            self.honorButtonClick(self.mrButton)
        }
        
        // Do any additional setup after loading the view.
    }
    // MARK: -
    @IBAction func honorButtonClick(_ sender: UIButton) {
        mrButton.isSelected = false
        msButton.isSelected = false
        mrsButton.isSelected = false
    
        sender.isSelected = true
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        
        
        var honor = ""
        if self.mrButton.isSelected {
            honor = "Mr"
        }else if self.msButton.isSelected {
            honor = "Ms"
        }else if self.mrsButton.isSelected {
            honor = "Mrs"
        }
        let model = AirTicketPassangerDetailsModel(honor: honor, first_name: self.firstNameView.text!, last_name: self.lastNameView.text!, dateOfBirth: self.dateOfBirthView.selectedDate, passportNumber: self.passportNumberView.text!, passportIssueDate: self.passportIssueDateView.selectedDate, passportExpiryDate: self.passportExpiryDateView.selectedDate, passportIssueCountry: self.passportIssueCountryView.text!, nationality: nationalityView.text!)
        
        let result = AirTicketValidation().ValidatePassangerDetails(passanger: model)
        
        if result.success {
            if self.completionBlock != nil {
                self.completionBlock!(model)
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.showAlert(title: "", message: result.error ?? "")
        }
    }
    
}
extension AirticketAddPassengerDetailViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        let vc = PCCPViewController() { countryDic in
            
            if let countryDic = countryDic as? [String:Any] {
                
                if let cntname = countryDic["country_code"] as? String{
                    
                    if textView == self.passportIssueCountryView {
                        self.passportIssueCountryView.text = cntname
                    }else if textView == self.nationalityView {
                        self.nationalityView.text = cntname
                    }
                }
            }
        }
        vc?.tableView.tintColor = .black
        let naviVC = UINavigationController(rootViewController: vc!)
        self.present(naviVC, animated: true, completion: nil)

    }
}
