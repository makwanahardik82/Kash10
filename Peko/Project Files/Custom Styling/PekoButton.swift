//
//  PekoButton.swift
//  Peko
//
//  Created by Hardik Makwana on 25/11/23.
//

import UIKit

enum PekoButtonStyle: String {
    case Plain
    case Submit
    case Submit_V2
//    case grey
//    case
}

class PekoButton: UIButton {

  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFont()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setText()
        self.setupFont()
    }
    
    @IBInspectable var textKey: String? {
        didSet {
            self.setText()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 1 {
        didSet {
            self.setupFont()
        }
    }
    
    @IBInspectable var buttonStyleName: String? {
        didSet {
            // Ensure user enters a valid shape while making it lowercase.
            // Default to a body style if not
            if let newStyle = PekoButtonStyle(rawValue: buttonStyleName?.capitalized ?? "Plain") {
                self.buttonStyle = newStyle
            }
        }
    }
    
    @IBInspectable var fontStyleName: String? {
        didSet {
            // Ensure user enters a valid shape while making it lowercase.
            // Default to a body style if not
            if let newStyle = FontStyle(rawValue: fontStyleName?.capitalized ?? "Regular") {
                self.fontStyle = newStyle
            }
        }
    }
    var fontStyle: FontStyle = .Regular {
        didSet {
            self.setupFont()
        }
    }
    var buttonStyle: PekoButtonStyle = .Plain {
        didSet {
            self.setupFont()
        }
    }
    // MARK: - Localized
    func setText(){
        if let key = self.textKey {
            self.setTitle(key.localizeString(), for: .normal)
        }
    }
    
    // MARK: - Setup Font
    func setupFont(){
        
        switch self.buttonStyle {
        
        case .Plain:
            switch self.fontStyle {
                
            case .Light:
                self.titleLabel?.font = UIFont.light(size: self.fontSize) // //AppFonts.Light.size(size: self.fontSize)
                break
            case .Regular:
                self.titleLabel?.font = UIFont.regular(size: self.fontSize) //AppFonts.Regular.size(size: self.fontSize)
                break
            case .Medium:
                self.titleLabel?.font = UIFont.medium(size: self.fontSize) // AppFonts.Medium.size(size: self.fontSize)
                break
            case .SemiBold:
                self.titleLabel?.font = AppFonts.SemiBold.size(size: Float(self.fontSize))
                break
            case .Bold:
                self.titleLabel?.font = UIFont.bold(size: self.fontSize) // AppFonts.Bold.size(size: self.fontSize)
                break
            case .ExtraBold:
                self.titleLabel?.font = AppFonts.ExtraBold.size(size: Float(self.fontSize))
                break
            }
            break
        case .Submit:
            if objShareManager.getAppTarget() == .PekoUAE {
                self.backgroundColor = .redButtonColor
            }else{
                self.backgroundColor = AppColors.blackThemeColor
            }
            self.layer.cornerRadius = 10
       
            self.titleLabel?.font = UIFont.bold(size: 16)
            self.setTitleColor(.white, for: .normal)
            self.layer.masksToBounds = true
            break
        case .Submit_V2:
            self.backgroundColor = .redButtonColor
            self.layer.cornerRadius = 5
       
            self.titleLabel?.font = UIFont.medium(size: 16) // bold(size: 18)
            self.setTitleColor(.white, for: .normal)
            self.layer.masksToBounds = true
        }
        
        
    }
    
}
