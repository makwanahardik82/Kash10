//
//  InvoiceDetailsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 28/02/24.
//

import UIKit

class InvoiceDetailsViewController: MainViewController {
    @IBOutlet weak var invoiceNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var invoiceDateView: PekoFloatingTextFieldView!
    @IBOutlet weak var dueDateView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var noteView: PekoFloatingTextView!
    @IBOutlet weak var termsView: PekoFloatingTextView!
    
    static func storyboardInstance() -> InvoiceDetailsViewController? {
        return AppStoryboards.InvoiceGenerator.instantiateViewController(identifier: "InvoiceDetailsViewController") as? InvoiceDetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Invoice Payments")
        
        // Do any additional setup after loading the view.
    }
    
        // MARK: - Next Button
    @IBAction func nextButtonClick(_ sender: Any) {
       
        let request = InvoiceDetailsRequest(invoiceNumber: self.invoiceNumberView.text, invoiceDate: self.invoiceDateView.selectedDate, dueDate: self.dueDateView.selectedDate, note: self.noteView.text, terms: self.termsView.text)
        
        let validationResult =  InvoiceGeneratorValidation().ValidateInvoiceDetails(request: request)
        
        if validationResult.success {
            objInvoiceGeneratorManager?.invoiceDetail = request
            if let itemVC = InvoiceGeneratorItemDetailViewController.storyboardInstance() {
                self.navigationController?.pushViewController(itemVC, animated: true)
            }
        }else{
            self.showAlert(title: "", message: validationResult.error ?? "")
        }
    }
}
