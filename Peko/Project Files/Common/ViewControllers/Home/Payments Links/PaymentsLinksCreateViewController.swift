//
//  PaymentsLinksCreateViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/05/23.
//

import UIKit
import KMPlaceholderTextView


class PaymentsLinksCreateViewController: MainViewController {

    @IBOutlet weak var createTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var checkButton: UIButton!
  
    @IBOutlet weak var nameView: PekoFloatingTextFieldView!
    @IBOutlet weak var amountView: PekoFloatingTextFieldView!
    @IBOutlet weak var phoneNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var emailView: PekoFloatingTextFieldView!
    
    
    @IBOutlet weak var noteView: PekoFloatingTextFieldView!
    @IBOutlet weak var expiryDateView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var uploadLogoView: DashedView!
    
    @IBOutlet weak var logoView: UIView!
    
    var imagePicker = UIImagePickerController()
    var imageBase64String:String = ""
    
    static func storyboardInstance() -> PaymentsLinksCreateViewController? {
        return AppStoryboards.PaymentsLinks.instantiateViewController(identifier: "PaymentsLinksCreateViewController") as? PaymentsLinksCreateViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Payments Links")
       
        self.createTableView.backgroundColor = .clear
        self.createTableView.tableHeaderView = self.headerView
        
        self.expiryDateView.delegate = self
        
        self.uploadLogoView.isHidden = false
        self.logoView.isHidden = true

    }
    
    // MARK: - Check Button
    @IBAction func checkButtonClick(_ sender: Any) {
        self.checkButton.isSelected = !self.checkButton.isSelected
        
        if self.checkButton.isSelected {
            self.expiryDateView.isHidden = true
        }else{
            self.expiryDateView.isHidden = false
        }
    }
    
    // MARK: - Logo Upload
    @IBAction func uploadLogoButtonClick(_ sender: Any) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    
    @IBAction func removeLogoButtonClick(_ sender: Any) {
        imageBase64String = ""
        self.uploadLogoView.isHidden = false
        self.logoView.isHidden = true
    }
    
    
    @IBAction func createDateButtonClick(_ sender: Any) {
       
        /*
        if let dateVC = DatePickerViewController.storyboardInstance() {
            dateVC.minimumDate = Date().addDays(day: 1)
            dateVC.completionBlock = { selectedDate in
                self.dateTxt.text = selectedDate.formate(format: "yyyy-MM-dd")
            }
            
            dateVC.modalPresentationStyle = .overCurrentContext
            dateVC.modalTransitionStyle = .crossDissolve
            self.present(dateVC, animated: true)
        }
         */
    }
    
    @IBAction func expiryDateButtonClick(_ sender: Any) {
   
    }
    
// MARK: - Create Button Click
    @IBAction func createButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        
        let createDate = Date().formate(format: "yyyy-MM-dd")

        let request = PaymentsLinksRequest(name: self.nameView.text!, amount: self.amountView.text!, email: self.emailView.text!, phoneNumber: self.phoneNumberView.text!, createDate: createDate, expiryDate: self.expiryDateView.text!, note: self.noteView.text!, noExpiry: self.checkButton.isSelected, imageBase64String: imageBase64String)
      
        let validationResult = PaymentsLinksValidation().Validate(request: request)

        if validationResult.success {
            self.createLink(request: request)
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
        
    }
    func createLink(request:PaymentsLinksRequest) {
        HPProgressHUD.show()
        
        PaymentLinkViewModel().createLink(request: request) { response, error in
            HPProgressHUD.hide()
            
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.goToShareVC(request: request, url: response?.data ?? "")
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }
                else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
            
        }
    }
    func goToShareVC(request:PaymentsLinksRequest, url:String) {
        if let shareVC = PaymentsLinksShareViewController.storyboardInstance() {
          
            shareVC.request = request
            shareVC.paymentLink = url
            self.navigationController?.pushViewController(shareVC, animated: true)
        }
    }
    
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

}
extension PaymentsLinksCreateViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        if textView == self.expiryDateView {
            
            DispatchQueue.main.async {
                if let calPopupVC = CalendarPopupViewController.storyboardInstance() {
                    calPopupVC.modalPresentationStyle = .overCurrentContext
                    calPopupVC.minimumDate = Date() // .addDays(day: 1)
                    calPopupVC.completionBlock = { selectedDate in
                        
                        DispatchQueue.main.async {
                            self.expiryDateView.text = selectedDate.formate(format: "yyyy-MM-dd")
                        }
                    }
                    self.present(calPopupVC, animated: false, completion: nil)
                }
            }
            
        }
    }
    
}
    
extension PaymentsLinksCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
          //  self.eidBaseString = image.toBase64() ?? ""
           // self.logoImgView.image = image
            self.uploadLogoView.isHidden = true
            self.logoView.isHidden = false
        }
    }
}
