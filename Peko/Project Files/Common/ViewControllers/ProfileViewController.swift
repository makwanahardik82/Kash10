//
//  ProfileViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/01/23.
//

import UIKit
import PhoneCountryCodePicker
import KMPlaceholderTextView
import Fastis

enum ImageUpload: Int {
    case Profile = 0
    case Trade_License
    case TRN_Certificat
    case VisaCopy
    case InitialArrroval
    case EID
}

class ProfileViewController: MainViewController {

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var firstLatterOfNameLabel: PekoLabel!
    
    @IBOutlet weak var accountIdLabel: PekoLabel!
    @IBOutlet weak var fullNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var phoneNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var emailView: PekoFloatingTextFieldView!

    @IBOutlet weak var genderView: PekoFloatingTextFieldView!
    @IBOutlet weak var dobView: PekoFloatingTextFieldView!
    
//    @IBOutlet weak var designationView: PekoFloatingTextFieldView!
//    @IBOutlet weak var emiratesView: PekoFloatingTextFieldView!
  
    //@IBOutlet weak var companySizeView: PekoFloatingTextFieldView!
//    @IBOutlet weak var landLineNumberView: PekoFloatingTextFieldView!
    
//    @IBOutlet weak var activityView: PekoFloatingTextFieldView!
//    @IBOutlet weak var tradeLicenseNumberView: PekoFloatingTextFieldView!
//    @IBOutlet weak var licenseAuthoirtyView: PekoFloatingTextFieldView!
//    @IBOutlet weak var trnNumberView: PekoFloatingTextFieldView!
//    
//    @IBOutlet weak var tradeLicenseUploadView: DashedView!
//    @IBOutlet weak var tradeLicensePhotoView: UIView!
//  
//    @IBOutlet weak var trnCertificateUploadView: DashedView!
//    @IBOutlet weak var trnCertificatePhotoView: UIView!
//  
//    @IBOutlet weak var properietorEIDUploadView: DashedView!
//    @IBOutlet weak var properietorEIDPhotoView: UIView!
  
    var imagePicker = UIImagePickerController()
    
    var imageUploadType:ImageUpload = .EID
    
    var eidBaseString:String = ""
    var tradeLicenseBaseString:String = ""
    var trnCertificateBaseString:String = ""
    
    var profileRequest:ProfileRequest?
    
    static func storyboardInstance() -> ProfileViewController? {
        return AppStoryboards.Profile.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "Profile")
        self.view.backgroundColor = .white
        
        self.profileTableView.backgroundColor = .clear
        self.headerView.backgroundColor = .clear
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        
        self.setData()
        
        self.profileTableView.tableHeaderView = self.headerView
        
        self.genderView.delegate = self
    }
    func setData() {
        
        DispatchQueue.main.async {
          //  self.logoImgView.sd_setImage(with: URL(string: (objUserSession.profileDetail?.logo ?? "")), placeholderImage: nil)
     
            self.accountIdLabel.text = "Account ID: " + objUserSession.username 
            self.firstLatterOfNameLabel.text = objUserSession.profileDetail?.name?.prefix(1).uppercased()

            self.fullNameView.text = (objUserSession.profileDetail?.name ?? "")
            
            // + " " + (objUserSession.profileDetail?.lastName ?? "")
            
            let countryCode = objUserSession.mobileCountryCode// "+\(objUserSession.profileDetail?.countryCode ?? "")"
            let number = (objUserSession.profileDetail?.mobileNo ?? "").replacingOccurrences(of: countryCode, with: "")
            self.phoneNumberView.text = number
         
            self.emailView.text = objUserSession.profileDetail?.email
          
            self.dobView.selectedDate = objUserSession.profileDetail?.dateDOB
            self.genderView.text = (objUserSession.profileDetail?.gender ?? "").capitalized
          
            /*
            self.designationView.text = objUserSession.profileDetail?.designation ?? ""
            self.emiratesView.text = objUserSession.profileDetail?.city ?? ""
            
            self.companySizeView.text = objUserSession.profileDetail?.companySize ?? ""
            self.landLineNumberView.text = objUserSession.profileDetail?.landlineNo ?? ""
            
            self.activityView.text = objUserSession.profileDetail?.activity ?? ""
         
            self.tradeLicenseNumberView.text = objUserSession.profileDetail?.tradeLicenseNo
            self.licenseAuthoirtyView.text = objUserSession.profileDetail?.issuingAuthority
            self.trnNumberView.text = objUserSession.profileDetail?.trnNo
           
            if (objUserSession.profileDetail?.tradeLicenseDoc) == nil || objUserSession.profileDetail?.tradeLicenseDoc?.count == 0 {
                self.tradeLicenseUploadView.isHidden = false
                self.tradeLicensePhotoView.isHidden = true
            }else{
                self.tradeLicenseUploadView.isHidden = true
                self.tradeLicensePhotoView.isHidden = false
            }
           
            if (objUserSession.profileDetail?.trnCertificate) == nil || objUserSession.profileDetail?.trnCertificate?.count == 0 {
                self.trnCertificateUploadView.isHidden = false
                self.trnCertificatePhotoView.isHidden = true
            }else{
                self.trnCertificateUploadView.isHidden = true
                self.trnCertificatePhotoView.isHidden = false
            }
            
            if (objUserSession.profileDetail?.eidDoc) == nil || objUserSession.profileDetail?.eidDoc?.count == 0 {
                self.properietorEIDUploadView.isHidden = false
                self.properietorEIDPhotoView.isHidden = true
            }else{
                self.properietorEIDUploadView.isHidden = true
                self.properietorEIDPhotoView.isHidden = false
            }
            */
        }
    }
   /*
    @IBAction func tradeLicenseButtonClick(_ sender: Any) {
        self.imageUploadType = .Trade_License
        self.imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func trnCertificateButtonClick(_ sender: Any) {
        self.imageUploadType = .TRN_Certificat
        self.imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func eidButtonClick(_ sender: Any) {
        self.imageUploadType = .EID
        self.imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func closeTradeLicenseButtonClick(_ sender: Any) {
        self.tradeLicenseBaseString = ""
        self.tradeLicenseUploadView.isHidden = false
        self.tradeLicensePhotoView.isHidden = true
    }
    @IBAction func closeLicenseButtonClick(_ sender: Any) {
        self.trnCertificateBaseString = ""
        self.trnCertificateUploadView.isHidden = false
        self.trnCertificatePhotoView.isHidden = true
        
    }
    @IBAction func closeeidButtonClick(_ sender: Any) {
        self.eidBaseString = ""
        self.properietorEIDUploadView.isHidden = false
        self.properietorEIDPhotoView.isHidden = true
    }
    */
    // MARK: - Update Button
    @IBAction func updateButtonClick(_ sender: Any) {
        
        self.view.endEditing(true)
// mobileNo: self.phoneNumberView.text, email: self.emailView.text,
       
        profileRequest = ProfileRequest(name: self.fullNameView.text!, mobileNumber: self.phoneNumberView.text, email: emailView.text!, dob: self.dobView.text!, gender: self.genderView.text!, selectedDOB: self.dobView.selectedDate)
     
        let validationResult = ProfileUpdateValidation().Validate(profileRequest: self.profileRequest!)
        
        if validationResult.success {
          //  self.sendOTP()
            self.updateProfile(otpString: "")
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
        
    }
    
    func getProfileData(msg:String){
        HPProgressHUD.show()
        DashboardViewModel().getProfileDetails() { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    objUserSession.profileDetail = response?.data
                    self.setData()
                    self.showAlert(title: "Success", message: msg)
                }
            }else{
//                var msg = ""
//                if response.message != nil {
//                    msg = response.message ?? ""
//                }else if response.error?.count != nil {
//                    msg = response.error ?? ""
//                }
//                self.showAlert(title: "", message: msg)
            }
        }
    }
    func sendOTP(){
        HPProgressHUD.show()
        OTPViewModel().generateOTPForUpdate { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.goToOTPView()
                }
            }else{
//                var msg = ""
//                if response.message != nil {
//                    msg = response.message ?? ""
//                }else if response.error?.count != nil {
//                    msg = response.error ?? ""
//                }
//                self.showAlert(title: "", message: msg)
            }
        }
    }
    func updateProfile(otpString:String) {
        HPProgressHUD.show()
        ProfileViewModel().updateProfileDetails(otp:otpString, profileRequest: profileRequest!) { response in

            print(response)
            if let status = response.status, status == true {
                DispatchQueue.main.async {
                    if let message = response.message {
                        self.getProfileData(msg: message)
                    }
                }
            }else{
                HPProgressHUD.hide()
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
    // MARK: -
    func goToOTPView(){
        if let otpVC = CommonOTPViewController.storyboardInstance() {
            otpVC.completionBlock = { otp in
                self.updateProfile(otpString: otp)
            }
            otpVC.modalPresentationStyle = .overCurrentContext
            otpVC.modalTransitionStyle = .crossDissolve
            self.present(otpVC, animated: true)
        }
    }
}
// MARK: -
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        dismiss(animated: true, completion: nil)
    
        if let image = info[.originalImage] as? UIImage {
           /*
            if imageUploadType == .EID {
                    self.eidBaseString = image.toBase64() ?? ""
                    self.properietorEIDUploadView.isHidden = true
                    self.properietorEIDPhotoView.isHidden = false
            }else if imageUploadType == .Trade_License {
                    self.tradeLicenseBaseString = image.toBase64() ?? ""
                    self.tradeLicenseUploadView.isHidden = true
                    self.tradeLicensePhotoView.isHidden = false
            }else if imageUploadType == .TRN_Certificat {
                    self.trnCertificateBaseString = image.toBase64() ?? ""
                    self.trnCertificateUploadView.isHidden = true
                    self.trnCertificatePhotoView.isHidden = false
            }
            */
        }
    }
}
extension ProfileViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        
        if textView == self.genderView {
            let pickerVC = PickerListViewController.storyboardInstance()
            pickerVC?.array = ["Male", "Female"]
            pickerVC?.selectedString = self.genderView.text!
            pickerVC?.titleString = "Gender"
            pickerVC?.completionBlock = { string in
                self.genderView.text = string
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let nav = UINavigationController(rootViewController: pickerVC!)
            nav.modalPresentationStyle = .fullScreen
            appDelegate.window?.rootViewController!.present(nav, animated: true)
        }
    }
    
    
}

/*
extension ProfileViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        
        if string == " " {
            return false
        }
        if textField == self.mobileNumberTxt || textField == self.phoneNumberTxt {
            return textField.numberValidation(number: string)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == self.emailTxt {
//            self.passwordTxt.becomeFirstResponder()
//        }else{
//            self.loginButtonClick(UIButton())
//        }
        return true
    }
}
*/
