//
//  InvoiceItemDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 17/03/24.
//

import UIKit

class InvoiceItemDetailViewController: MainViewController {

    @IBOutlet weak var descView: PekoFloatingTextView!
    @IBOutlet weak var qtyView: PekoFloatingTextFieldView!
    @IBOutlet weak var priceView: PekoFloatingTextFieldView!
    @IBOutlet weak var vatView: PekoFloatingTextFieldView!
    @IBOutlet weak var discountView: PekoFloatingTextFieldView!
    @IBOutlet weak var amountView: PekoFloatingTextFieldView!
    
    
    var completionBlock:((_ model:InvoiceItemDetailModel) -> Void)?
    
    var isEdit:Bool = false
    var itemDetailModel = InvoiceItemDetailModel()
    
    static func storyboardInstance() -> InvoiceItemDetailViewController? {
        return AppStoryboards.InvoiceGenerator.instantiateViewController(identifier: "InvoiceItemDetailViewController") as? InvoiceItemDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

     //
        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Create Invoice")
     
      //  descView.delegate = self
        qtyView.delegate = self
        priceView.delegate = self
        vatView.delegate = self
        discountView.delegate = self
       // amountView.delegate = self
        
        self.amountView.borderView.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
    
        if isEdit {
            self.descView.text = self.itemDetailModel.desc ?? ""
            self.qtyView.text = self.itemDetailModel.qty ?? ""
            self.priceView.text = self.itemDetailModel.price ?? ""
            self.vatView.text = self.itemDetailModel.vat ?? ""
            self.discountView.text = self.itemDetailModel.discount ?? ""
            self.amountView.text = self.itemDetailModel.total ?? ""
            self.updateValues()
        }
        
        // Do any additional setup after loading the view.
    }
    func updateValues(){
           let qty = Double(self.qtyView.text ?? "0") ?? 0.0
           let price = Double(self.priceView.text ?? "0") ?? 0.0
           let discount = Double(self.discountView.text ?? "0") ?? 0.0
           let vat = Double(self.vatView.text ?? "0") ?? 0.0
           let amount = qty * price
           self.amountView.text = "\((amount + vat) - discount)"
   
        //   self.itemDetailModel.total = "\(amount)"
//           textChanged?(str)
       }
    // MARK: - Add Item
    @IBAction func addItemButtonClick(_ sender: Any) {
        
        let itemModel = InvoiceItemDetailModel(desc: self.descView.text, qty: self.qtyView.text, price: self.priceView.text, vat: self.vatView.text, discount: self.discountView.text, total: self.amountView.text)
           
        
        let validationResult =  InvoiceGeneratorValidation().ValidateItem(item: itemModel)
        
        if validationResult.success {
            if self.completionBlock != nil {
                self.completionBlock!(itemModel)
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            self.showAlert(title: "", message: validationResult.error ?? "")
        }
    }
    
}
extension InvoiceItemDetailViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        /*
        if textView == self.descTxt {
            self.itemDetailModel.desc = textView.text!
        }else
        */
        
        self.updateValues()
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        
        if textView == self.qtyView {
            let pickerVC = PickerListViewController.storyboardInstance()
            pickerVC?.array = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
            pickerVC?.selectedString = self.qtyView.text!
            pickerVC?.titleString = "Mode of payment"
            pickerVC?.completionBlock = { string in
                self.qtyView.text = string
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let nav = UINavigationController(rootViewController: pickerVC!)
            nav.modalPresentationStyle = .fullScreen
            appDelegate.window?.rootViewController!.present(nav, animated: true)
//
//            let nav = UINavigationController(rootViewController: pickerVC!)
//            nav.modalPresentationStyle = .fullScreen
//            self.present(nav, animated: true)
        }
    }
}
extension InvoiceItemDetailViewController:PekoFloatingTextViewDelegate{
    func textChange(textView: PekoFloatingTextView) {
//        if textView == self.descView {
//            self.itemDetailModel.desc = textView.text!
//        }
       // self.updateValues()
    }
    
    
}
