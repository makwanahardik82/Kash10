//
//  HotelBookingGuestDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 13/03/24.
//

import UIKit
import PhoneCountryCodePicker

class HotelBookingGuestDetailViewController: MainViewController {

    @IBOutlet weak var firstNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var lastNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var emailView: PekoFloatingTextFieldView!
    @IBOutlet weak var mobileNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var countryView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var mrButton: PekoButton!
    @IBOutlet weak var msButton: PekoButton!
    @IBOutlet weak var mrsButton: PekoButton!
    
    var isEdit = false
    var completionBlock:((_ model:HotelBookingGuestModel) -> Void)?
    
    var editGuestModel:HotelBookingGuestModel?
    
    static func storyboardInstance() -> HotelBookingGuestDetailViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingGuestDetailViewController") as? HotelBookingGuestDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Guests Details")
        self.view.backgroundColor = .white
   
        self.countryView.delegate = self
        
        if self.isEdit {
            
            if editGuestModel?.honor == "Mr" {
                self.honorButtonClick(self.mrButton)
            }else if editGuestModel!.honor == "Ms" {
                self.honorButtonClick(self.msButton)
            }else if editGuestModel!.honor == "Mrs"{
                self.honorButtonClick(self.mrsButton)
            }
            firstNameView.text = self.editGuestModel?.first_name
            lastNameView.text = self.editGuestModel?.last_name
            emailView.text = self.editGuestModel?.email
            mobileNumberView.text = self.editGuestModel?.phone_number
            countryView.text = self.editGuestModel?.country
            
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
    
    // MARK: -
    @IBAction func saveButtonClick(_ sender: Any) {
        
        let guestModel = HotelBookingGuestModel()
        
        if self.mrButton.isSelected {
            guestModel.honor = "Mr"
        }else if self.msButton.isSelected {
            guestModel.honor = "Ms"
        }else if self.mrsButton.isSelected {
            guestModel.honor = "Mrs"
        }
        
        guestModel.first_name = firstNameView.text!
        guestModel.last_name = lastNameView.text!
        guestModel.email = emailView.text!
        guestModel.phone_number = mobileNumberView.text!
        guestModel.country = countryView.text!
        
        let result = HotelBookingValidation().ValidateGuestDetails(passanger: guestModel)
        if result.success {
            if completionBlock != nil {
                self.completionBlock!(guestModel)
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            self.showAlert(title: "", message: result.error ?? "")
        }
    }
}
extension HotelBookingGuestDetailViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        if textView == self.countryView {
            let vc = PCCPViewController() { countryDic in
                
                if let countryDic = countryDic as? [String:Any] {
                    
                    if let cntname = countryDic["country_en"] as? String{
                        self.countryView.text = cntname
                       // self.setStatesArray(country: cntname)
                    }
                }
            }
            vc?.tableView.tintColor = .black
            let naviVC = UINavigationController(rootViewController: vc!)
            self.present(naviVC, animated: true, completion: nil)
        }
    }
}
