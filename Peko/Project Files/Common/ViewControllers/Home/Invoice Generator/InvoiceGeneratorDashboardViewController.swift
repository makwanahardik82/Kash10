//
//  InvoiceGeneratorDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 06/06/23.
//

import UIKit
import KMPlaceholderTextView

import Fastis

class InvoiceGeneratorDashboardViewController: MainViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var uploadView: DashedView!
    @IBOutlet weak var logoView: UIView!
    
    @IBOutlet weak var billerNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var billerEmailView: PekoFloatingTextFieldView!
    @IBOutlet weak var billerMobileNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var billerCompanyAddressView: PekoFloatingTextFieldView!
    @IBOutlet weak var billerGstNumberView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var customerNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var customerEmailView: PekoFloatingTextFieldView!
    @IBOutlet weak var customerMobileNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var customerAddressView: PekoFloatingTextFieldView!
    
    var imagePicker = UIImagePickerController()
    var logoBase64String = ""
    
    /*
    var request = InvoiceGeneratorRequestModel()
    
    var fromDate = Date()// .last30Day()
    var toDate = Date()
    
    var searchArray = [InvoiceGeneratorResponseModel]()
    var invoiceArray = [InvoiceGeneratorResponseModel]()
    */
    
    static func storyboardInstance() -> InvoiceGeneratorDashboardViewController? {
        return AppStoryboards.InvoiceGenerator.instantiateViewController(identifier: "InvoiceGeneratorDashboardViewController") as? InvoiceGeneratorDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Invoice Payments")
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.logoView.isHidden = true
        
        objInvoiceGeneratorManager = InvoiceGeneratorManager.sharedInstance
      
        self.backNavigationView?.orderHistoryView.isHidden = false
        self.backNavigationView?.historyButton.addTarget(self, action: #selector(historyButtonClick), for: .touchUpInside)
       
    }
   // MARK: - Booking History Button
    @objc func historyButtonClick(){
        if let historyVC = InvoiceHistoryViewController.storyboardInstance(){
            self.navigationController?.pushViewController(historyVC, animated: true)
        }
    }
    
    // MARK: - Upload Logo
    @IBAction func uploadLogoButtonClick(_ sender: Any) {
        self.imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func removeLogoButtonClick(_ sender: Any) {
        self.uploadView.isHidden = false
        self.logoView.isHidden = true
    }
    
    // MARK: -
    @IBAction func submitButtonClick(_ sender: Any) {
        
        let request = InvoiceBillerDetailsRequest(logoBase64String: self.logoBase64String, billerName: self.billerNameView.text, billerEmail: self.billerEmailView.text, billerMobileNumber: self.billerMobileNumberView.text, billerCompanyAddress: self.billerCompanyAddressView.text, billerGstNumber: self.billerGstNumberView.text, customerName: self.customerNameView.text, customerEmail: self.customerEmailView.text, customerMobileNumber: self.customerMobileNumberView.text, customerAddress: self.customerAddressView.text)
        
        let validationResult =  InvoiceGeneratorValidation().ValidateBillerDetails(request: request)
        
        if validationResult.success {
            objInvoiceGeneratorManager?.billerDetail = request
            if let detailVC = InvoiceDetailsViewController.storyboardInstance() {
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }else{
            self.showAlert(title: "", message: validationResult.error ?? "")
        }
    }
}
     
// MARK: -
extension InvoiceGeneratorDashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            self.logoBase64String = image.toBase64() ?? ""
            self.uploadView.isHidden = true
            self.logoView.isHidden = false
        }
    }
}
