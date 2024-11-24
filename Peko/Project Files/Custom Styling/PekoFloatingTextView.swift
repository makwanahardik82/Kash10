//
//  PekoFloatingTextView.swift
//  Peko
//
//  Created by Hardik Makwana on 22/02/24.
//

import UIKit
import KMPlaceholderTextView

protocol PekoFloatingTextViewDelegate: UITextFieldDelegate {

    func textChange(textView:PekoFloatingTextView)
  //  func dropDownClick(textView:PekoFloatingTextFieldView)
//    @objc optional func didTapOnRightView(textField: SKFloatingTextField)
//    @objc optional func textFieldDidEndEditing(textField : SKFloatingTextField)
//    @objc optional func textFieldDidChangeSelection(textField: SKFloatingTextField)
//    @objc optional func textFieldDidBeginEditing(textField: SKFloatingTextField)
}

class PekoFloatingTextView: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
   
    @IBOutlet weak var borderView: UIView!
   
    public var border_color: UIColor = .textFieldBorderColor //UIColor(named: "EAEAEA")!
    public var border_width: CGFloat = 1
    public var corner_radius: CGFloat = 10
    public var textColor: UIColor?
    
    var delegate:PekoFloatingTextViewDelegate?
   
    public var text: String? {
        get {
            return textView.text
        }set {
            textView.text = newValue
            self.textViewDidChange(self.textView)
        }
    }
   
    // MARK: - placeholder
    @IBInspectable var placeholder: String = "" {
        didSet {
            let color = UIColor(red: 148/255.0, green: 148/255.0, blue: 148/255.0, alpha: 1.0)
            textView.placeholder = self.placeholder.localizeString()
            textView.placeholderColor = color
            textView.placeholderFont = AppFonts.Regular.size(size: 14)
            
            self.titleLabel.text = self.placeholder.localizeString()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
         commoninit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
         commoninit()
    }
    private func commoninit(){
      //  Bundle(identifier: "org.cocoapods.SKFloatingtextView")?.loadNibNamed("SKFloatingtextView", owner: self, options: nil)
        let nib = UINib(nibName: "PekoFloatingTextView", bundle: nil)
        contentView =  (nib.instantiate(withOwner: self, options: nil).first as! UIView)
//        addSubview(contentView)
        insertSubview(contentView, at: 0)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
      //  self.titleLabel.isHidden = true
        self.titleLabel.textAlignment = .left
        self.titleLabel.font = AppFonts.Regular.size(size: 12)
        self.titleLabel.textColor = .grayTextColor
        
        //UIColor(red:148/255.0, green:148/255.0, blue:  148/255.0, alpha: 1.0)
        
        
        self.textView.font = AppFonts.Regular.size(size: 14)
        self.borderView.layer.cornerRadius = self.corner_radius
        self.borderView.layer.borderColor = self.border_color.cgColor
        self.borderView.layer.borderWidth = self.border_width
        self.borderView.layer.masksToBounds = true
        
//        self.textView.addTarget(self, action: #selector(textViewDidEndEditing), for: .editingDidEnd)
//        self.textView.addTarget(self, action: #selector(textViewDidBeginEditing), for: .editingDidBegin)
//        self.textView.addTarget(self, action: #selector(textViewDidChangeSelection), for: .editingChanged)
       
        self.textView.tintColor = .black
        self.textView.delegate = self
        self.hideFloatingTitle()
    }

    public func showFloatingTitle() {
        self.titleView.isHidden = false
    }
    public func hideFloatingTitle() {
        self.titleView.isHidden = true
    }
    
}
extension PekoFloatingTextView:UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView.text == "" {
            self.textView.placeholder = self.placeholder.localizeString()
            self.hideFloatingTitle()
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.showFloatingTitle()
        self.textView.placeholder = ""
      
    }
    func textViewDidChange(_ textView: UITextView) {
        if self.textView.text == "" {
            self.textView.placeholder = self.placeholder.localizeString()
            self.hideFloatingTitle()
        }else{
            self.showFloatingTitle()
            self.textView.placeholder = ""
        }
        if self.delegate != nil {
            self.delegate?.textChange(textView: self)
        }
        
//        if self.delegate != nil {
//            self.delegate?.textChange(textView: self)
//        }
    }
//    @objc fileprivate func textFieldDidEndEditing() {
//        if self.textField.text == "" {
//            self.textField.placeholder = self.placeholder.localizeString()
//            self.hideFloatingTitle()
//        }
////        else if self.isValidInput {
////            self.errorLabelText = ""
////        }
//        
//      //  self.borderView.layer.borderColor = self.borderColor?.cgColor
//        //self.delegate?.textFieldDidEndEditing?(textField: self)
//    }
//    @objc fileprivate func textFieldDidBeginEditing() {
//        self.showFloatingTitle()
//        self.textField.placeholder = ""
//      //  self.borderView.layer.borderColor = self.active_color.cgColor
//       // }
//      //  self.delegate?.textFieldDidBeginEditing?(textField: self)
//    }
    /*
    @objc fileprivate func textFieldDidChangeSelection() {
        
        if self.textField.text == "" {
            self.textField.placeholder = self.placeholder.localizeString()
            self.hideFloatingTitle()
        }else{
            self.showFloatingTitle()
            self.textField.placeholder = ""
        }
      
        if self.delegate != nil {
            self.delegate?.textChange(textView: self)
        }
        
 //       self.borderView.layer.borderColor = self.active_color.cgColor
      //  self.errorLabelText = ""
//        if let color = self.activeBorderColor {
//            self.textField.layer.borderColor = color.cgColor
//        }
        // self.delegate?.textFieldDidChangeSelection?(textField: self)
    }
    */
}
