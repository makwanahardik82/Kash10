//
//  PekoOTPView.swift
//  Peko
//
//  Created by Hardik Makwana on 06/12/23.
//

import UIKit

class PekoOTPView: UIView {

    @IBOutlet weak var label_1: UILabel!
    @IBOutlet weak var label_2: UILabel!
    @IBOutlet weak var label_3: UILabel!
    @IBOutlet weak var label_4: UILabel!
    @IBOutlet weak var label_5: UILabel!
    @IBOutlet weak var label_6: UILabel!
   
    @IBOutlet weak var textfield: UITextField!
    var view: UIView!
    
    var otpArray = ["", "", "", "", "", ""]
    
    var otpString:String {
        get{
            return self.otpArray.joined(separator: "")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.backgroundColor = .clear
        view.clipsToBounds = true
        // Adding custom subview on top of our view
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view!]))
        
        
        self.textfield.delegate = self
        self.textfield.textColor = .clear
        self.textfield.tintColor = .white
        
        self.label_1.text = ""
        self.label_2.text = ""
        self.label_3.text = ""
        self.label_4.text = ""
        self.label_5.text = ""
        self.label_6.text = ""
    }
    
    func loadNib() -> UIView {
        //        let bundle = Bundle(for: type(of: self))
        //        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: "PekoOTPView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func displayCodeInTextField() {
        
        self.label_1.text = self.otpArray[0]//  as? String)
        self.label_2.text = self.otpArray[1] //as? String)
        self.label_3.text = self.otpArray[2] // as? String
        self.label_4.text = self.otpArray[3]
        self.label_5.text = self.otpArray[4] // as? String
        self.label_6.text = self.otpArray[5]
    }
    func clearOTP(){
        self.label_1.text = ""
        self.label_2.text = ""
        self.label_3.text = ""
        self.label_4.text = ""
        self.label_5.text = ""
        self.label_6.text = ""
        
        self.textfield.text = ""
        
        self.otpArray = ["", "", "", "", "", ""]
    }
}
// MARK: - Textfield
extension PekoOTPView:UITextFieldDelegate {
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        if string == "" {
            self.otpArray[range.location] = string
            self.displayCodeInTextField()
            return true
        }else if string == " " {
            return false
        }
        if textField == self.textfield {
            if textField.text!.count == 6 {
                return false
            }
            
            let result = textField.numberValidation(number: string)
            
            if result {
                if string.count == 6 {
                    let array = string.map({ String($0) })
                    self.otpArray = array
                    self.textfield.text = ""
                   // return true
                }else if string.count == 1  {
                    self.otpArray[range.location] = string
                }
                self.displayCodeInTextField()
            }
            return result
            
        }
        return false
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
