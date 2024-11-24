//
//  PekoTextFieldView.swift
//  Peko
//
//  Created by Hardik Makwana on 19/02/24.
//

import UIKit


protocol PekoTextFieldDelegate: UITextFieldDelegate {

    func textChange(textField:PekoTextField)

}
class PekoTextField: UITextField {
    
    var pekoTextFieldViewDelegate:PekoTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    func setup(){
        self.delegate = self
        
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
      
        
    }
    
    @IBInspectable var textFieldTypeName: String? {
        didSet {
            if let newStyle = TextFieldType(rawValue: textFieldTypeName?.capitalized ?? "Default") {
                self.textFieldType = newStyle
            }
        }
    }
    
    var textFieldType: TextFieldType = .Default {
        didSet {
            self.setupTextField()
        }
    }
    
    func setupTextField(){
        switch self.textFieldType {
        case .Default:
            self.keyboardType = .default
            break
        case .Username:
            self.keyboardType = .default
            self.textContentType = .username
            break
        case .Password:
            self.keyboardType = .default
            self.textContentType = .password
            self.rightViewMode = UITextField.ViewMode.always
            self.isSecureTextEntry = true
            let width = self.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: width))
            
            let button = UIButton(frame: view.bounds)
            button.setImage(UIImage(named: "icon_password_eye"), for: .normal)
            button.setImage(UIImage(named: "icon_password_eye_slash"), for: .selected)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(eyeButtonClick), for: .touchUpInside)
            view.addSubview(button)
            view.backgroundColor = .clear
            self.rightView = view
            
            break
        case .Email:
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
            break
        case .Number:
            self.keyboardType = .numberPad
            
            break
        case .Decimal:
            self.keyboardType = .decimalPad
            
            break
        case .Dropdown:
            self.keyboardType = .default
            
            self.rightViewMode = UITextField.ViewMode.always
            
            let width = self.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: width))
            
            let imageView = UIImageView(frame: view.bounds)
            imageView.image = UIImage(named: "icon_arrow_down_black")
            imageView.contentMode = .center
            view.addSubview(imageView)
            view.backgroundColor = .clear
            self.rightView = view
            
            self.isUserInteractionEnabled = false
            break
        case .Phone:
            self.keyboardType = .numberPad
            self.textContentType = .telephoneNumber
            let width = self.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: width))
            view.backgroundColor = .clear
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: width))
            imageView.image = UIImage(named: "icon_country_flag")
            imageView.contentMode = .center
            view.addSubview(imageView)
            
            let label = UILabel(frame: CGRect(x: 34, y: 0, width: 35, height: width))
            label.font = AppFonts.Regular.size(size: 14)
            
            label.text = objUserSession.mobileCountryCode
            view.addSubview(label)
            
            self.leftViewMode = UITextField.ViewMode.always
            self.leftView = view
            
            break
        case .Mobile:
            self.keyboardType = .numberPad
            self.textContentType = .telephoneNumber
            let width = self.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: width))
            view.backgroundColor = .clear
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: width))
            label.font = AppFonts.Regular.size(size: 14)
            label.text = objUserSession.mobileCountryCode
            view.addSubview(label)
            
            self.leftViewMode = UITextField.ViewMode.always
            self.leftView = view
            break
        case .Calendar:
            
            break
        }
    }
    // MARK: - Eye Button Click
    @objc func eyeButtonClick(_ sender: UIButton) {
        self.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
}
extension PekoTextField{
//    @objc fileprivate func textFieldDidEndEditing() {
//        if self.text == "" {
//            self.placeholder = self.placeholder.localizeString()
//            self.hideFloatingTitle()
//        }
//    }
//    @objc fileprivate func textFieldDidBeginEditing() {
//        self.showFloatingTitle()
//        self.placeholder = ""
//        //  self.borderView.layer.borderColor = self.active_color.cgColor
//        // }
//        //  self.delegate?DidBeginEditing?(textField: self)
//    }
    @objc func textFieldDidChange(_ textField: PekoTextField) {
        if self.pekoTextFieldViewDelegate != nil {
            self.pekoTextFieldViewDelegate?.textChange(textField: self)
        }
    }
    
}
extension PekoTextField:UITextFieldDelegate{
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        /*
         switch self.textFieldType {
         case .Default:
         // self.textField.keyboardType = .default
         break
         case .Username:
         if string == " " {
         return false
         }
         break
         case .Password:
         
         break
         case .Email:
         if string == " " {
         return false
         }
         break
         case .Number:
         
         
         case .Decimal:
         
         
         }
         */
        
        if self.textFieldType == .Number || self.textFieldType == .Phone || self.textFieldType == .Mobile {
            return textField.numberValidation(number: string)
        }else if self.textFieldType == .Decimal {
            return textField.decimalNumberValidation(number: string)
        }else if self.textFieldType == .Username {
            if string == " " {
                return false
            }
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
