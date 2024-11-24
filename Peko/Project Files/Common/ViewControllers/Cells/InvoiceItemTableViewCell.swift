//
//  InvoiceItemTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 02/07/23.
//

import UIKit

class InvoiceItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var amountLabel: PekoLabel!
    
//    
//    @IBOutlet weak var descView: PekoFloatingTextView!
//    @IBOutlet weak var qtyView: PekoFloatingTextFieldView!
//    @IBOutlet weak var priceView: PekoFloatingTextFieldView!
//    @IBOutlet weak var vatView: PekoFloatingTextFieldView!
//    @IBOutlet weak var discountView: PekoFloatingTextFieldView!
//    @IBOutlet weak var totalView: PekoFloatingTextFieldView!
//    
//    var textChanged: ((String) -> Void)?
//    var itemDetailModel = InvoiceItemDetailModel()
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        descView.delegate = self
        qtyView.delegate = self
        priceView.delegate = self
        vatView.delegate = self
        discountView.delegate = self
        totalView.delegate = self
        
        self.totalView.borderView.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
        */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textChanged(action: @escaping (String) -> Void) {
      //  self.textChanged = action
    }
    
    // MARK: - textFieldDidChange
   // @objc func textFieldDidChange(_ textField: UITextField) {
        
//        if textField == self.descTxt {
//            self.itemDetailModel.desc = textField.text!
//        }else if textField == self.qtyTxt {
//            self.itemDetailModel.qty = textField.text!
//        }else if textField == self.rateTxt {
//            self.itemDetailModel.rate = textField.text!
//        }
//        
//        
//        let qty = Double(self.rateTxt.text ?? "0") ?? 0.0
//        let rate = Double(self.qtyTxt.text ?? "0") ?? 0.0
//        let amount = qty * rate
//        self.amountTxt.text = "\(amount)"
//        self.itemDetailModel.amount = "\(amount)"
//        textChanged?(textField.text!)
   // }
//    func updateValues(str:String){
//        let qty = Double(self.qtyView.text ?? "0") ?? 0.0
//        let price = Double(self.priceView.text ?? "0") ?? 0.0
//        let discount = Double(self.discountView.text ?? "0") ?? 0.0
//        let vat = Double(self.vatView.text ?? "0") ?? 0.0
//        let amount = qty * price
//        self.totalView.text = "\((amount + vat) - discount)"
//       
//        self.itemDetailModel.total = "\(amount)"
//        textChanged?(str)
//    }
}
/*
// MARK: -
extension InvoiceItemTableViewCell:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        /*
        if textView == self.descTxt {
            self.itemDetailModel.desc = textView.text!
        }else
        */
        if textView == self.qtyView {
            self.itemDetailModel.qty = textView.text!
        }else if textView == self.priceView {
            self.itemDetailModel.price = textView.text!
        }else if textView == self.vatView {
            self.itemDetailModel.vat = textView.text!
        }else if textView == self.discountView {
            self.itemDetailModel.discount = textView.text!
        }
        self.updateValues(str: textView.text!)
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
extension InvoiceItemTableViewCell:PekoFloatingTextViewDelegate{
    func textChange(textView: PekoFloatingTextView) {
        if textView == self.descView {
            self.itemDetailModel.desc = textView.text!
        }
        self.updateValues(str: textView.text!)
    }
    
    
}
*/
/*
extension InvoiceItemTableViewCell:UITextFieldDelegate{
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        if string == "" {
            return true
        }else if string == " " {
            return false
        }
        
        if textField == self.qtyTxt {
            return textField.numberValidation(number: string)
        }
        
        if textField == self.rateTxt || textField == self.amountTxt {
            return textField.decimalNumberValidation(number: string)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
*/

struct InvoiceItemDetailModel: Codable {
    
    var desc:String? // = ""
    var qty:String? // = ""
    var price:String? // = ""
    var vat:String? // = ""
    var discount:String? // = ""
    var total:String? // = ""
    
}
