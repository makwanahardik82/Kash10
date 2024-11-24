//
//  PekoLabel.swift
//  Peko
//
//  Created by Hardik Makwana on 25/11/23.
//

import UIKit

@IBDesignable
class PekoLabel: UILabel {

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
    @IBInspectable var fontStyleName: String? {
        didSet {
            // Ensure user enters a valid shape while making it lowercase.
            // Default to a body style if not
            if let newStyle = FontStyle(rawValue: fontStyleName?.capitalized ?? "Regular") {
                self.fontStyle = newStyle
            }
        }
    }
    @IBInspectable var textColorHex: String? {
        didSet {
            if let hex = self.textColorHex {
                self.textColor = UIColor(named: hex)
            }
           
        }
    }
    @IBInspectable var backgroundColorHex: String? {
        didSet {
            if let hex = self.backgroundColorHex {
                self.backgroundColor = UIColor(named: hex)
            }
           
        }
    }
    var fontStyle: FontStyle = .Regular {
        didSet {
            self.setupFont()
        }
    }
    
    // MARK: - Localized
    func setText(){
        if let key = self.textKey {
            self.text = key.localizeString()
        }
    }
    
    // MARK: - Setup Font
    func setupFont(){
        switch self.fontStyle {
            
        case .Light:
            self.font = UIFont.light(size: self.fontSize) // //AppFonts.Light.size(size: self.fontSize)
            break
        case .Regular:
            self.font = UIFont.regular(size: self.fontSize) //AppFonts.Regular.size(size: self.fontSize)
            break
        case .Medium:
            self.font = UIFont.medium(size: self.fontSize) // AppFonts.Medium.size(size: self.fontSize)
            break
        case .SemiBold:
            self.font = AppFonts.SemiBold.size(size: Float(self.fontSize))
            break
        case .Bold:
            self.font = UIFont.bold(size: self.fontSize) // AppFonts.Bold.size(size: self.fontSize)
            break
        case .ExtraBold:
            self.font = AppFonts.ExtraBold.size(size: Float(self.fontSize))
            break
        }
    }
}
