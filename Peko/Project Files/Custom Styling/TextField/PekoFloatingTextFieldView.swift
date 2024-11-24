
import UIKit

enum TextFieldType: String {
    case Default
    case Username // 300
    case Password // 400
    case Email // 500
    case Number // 600
    case Decimal // 700
    case Dropdown
    case Phone
    case Mobile
    case Calendar
//    case ExtraBold // 800
}

protocol PekoFloatingTextFieldViewDelegate: UITextFieldDelegate {

    func textChange(textView:PekoFloatingTextFieldView)
    func dropDownClick(textView:PekoFloatingTextFieldView)
//    @objc optional func didTapOnRightView(textField: SKFloatingTextField)
//    @objc optional func textFieldDidEndEditing(textField : SKFloatingTextField)
//    @objc optional func textFieldDidChangeSelection(textField: SKFloatingTextField)
//    @objc optional func textFieldDidBeginEditing(textField: SKFloatingTextField)
}

class PekoFloatingTextFieldView : UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bottomErrorLabel: UILabel!
   
    @IBOutlet weak var borderView: UIView!
   
    public var border_color: UIColor = .textFieldBorderColor //UIColor(named: "EAEAEA")!
    public var border_width: CGFloat = 1
    public var corner_radius: CGFloat = 10
    public var textColor: UIColor?
    
    var phoneCodeLabel:UILabel?
    
    var selectedDate:Date? {
//        get{
//            return self.selectedDate
//        }
        willSet{
            self.textField.text = newValue!.formate(format: "dd, MMMM, yyyy")
        }
    }
    var delegate:PekoFloatingTextFieldViewDelegate?
   
    var minimumDate:Date?
    var maximumDate:Date?
    
    // MARK: - LEFT IMAGE
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
   
    func updateView() {
        if let image = leftImage {
            self.textField.leftViewMode = UITextField.ViewMode.always
           
           
            let width = self.textField.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: width))
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))// (frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.center = CGPoint(x: 20, y: width / 2)
            view.addSubview(imageView)
          //  imageView.center = CGPoint(x: view.bounds.width / 2, y: width / 2)
            self.textField.leftView = view
            
            self.textField.backgroundColor = .clear
            view.backgroundColor = .clear
        } else {
            self.textField.leftViewMode = UITextField.ViewMode.never
            self.textField.leftView = nil
        }
    }

//    @IBInspectable
//    public var active_color: UIColor = .black
    
    @IBInspectable
    public var isSecureTextInput: Bool {
        get {
            return self.textField.isSecureTextEntry
        }
        set {
            self.textField.isSecureTextEntry = newValue
        }
    }
    
    public var text: String? {
        get {
            return textField.text
        }set {
            if newValue != nil {
                DispatchQueue.main.async {
                    self.textField.text = newValue
                    self.textFieldDidChangeSelection()
                }
                
            }
        }
    }
   
    // MARK: - placeholder
    @IBInspectable var placeholder: String = "" {
        didSet {
            let color = UIColor(red: 148/255.0, green: 148/255.0, blue: 148/255.0, alpha: 1.0)
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder.localizeString(), attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : AppFonts.Regular.size(size: 14)])
            self.titleLabel.text = self.placeholder.localizeString()
        }
    }
    
    @IBInspectable var textFieldTypeName: String? {
        didSet {
            // Ensure user enters a valid shape while making it lowercase.
            // Default to a body style if not
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
            self.textField.keyboardType = .default
            break
        case .Username:
            self.textField.keyboardType = .default
            self.textField.textContentType = .username
            break
        case .Password:
            self.textField.keyboardType = .default
            self.textField.textContentType = .password
            self.textField.rightViewMode = UITextField.ViewMode.always
            self.textField.isSecureTextEntry = true
            let width = self.textField.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: width))
          
            let button = UIButton(frame: view.bounds)
            button.setImage(UIImage(named: "icon_password_eye"), for: .normal)
            button.setImage(UIImage(named: "icon_password_eye_slash"), for: .selected)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(eyeButtonClick), for: .touchUpInside)
            view.addSubview(button)
            view.backgroundColor = .clear
            self.textField.rightView = view

            break
        case .Email:
            self.textField.keyboardType = .emailAddress
            self.textField.textContentType = .emailAddress
            break
        case .Number:
            self.textField.keyboardType = .numberPad
            self.textField.leftViewMode = .never
            break
        case .Decimal:
            self.textField.keyboardType = .decimalPad

            break
        case .Dropdown:
            self.textField.keyboardType = .default
            
            self.textField.rightViewMode = UITextField.ViewMode.always
            
            let width = self.textField.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: width))
          
            let imageView = UIImageView(frame: view.bounds)
            imageView.image = UIImage(named: "icon_arrow_down_black")
            imageView.contentMode = .center
            view.addSubview(imageView)
            view.backgroundColor = .clear
            self.textField.rightView = view
            
            self.textField.isUserInteractionEnabled = false
            
            let dropButton = UIButton(frame: CGRect(x: 0, y: 6, width: self.textField.bounds.width, height: self.textField.bounds.height))
            dropButton.addTarget(self, action: #selector(dropDownButtonClick), for: .touchUpInside)
            dropButton.backgroundColor = .clear
            self.addSubview(dropButton)
            
            break
        case .Phone:
            self.textField.keyboardType = .numberPad
            self.textField.textContentType = .telephoneNumber
            let width = self.textField.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: width))
            view.backgroundColor = .clear
          
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: width))
            imageView.image = UIImage(named: "icon_country_flag")
            imageView.contentMode = .center
            view.addSubview(imageView)
          
            self.phoneCodeLabel = UILabel(frame: CGRect(x: 34, y: 0, width: 35, height: width))
            self.phoneCodeLabel!.font = AppFonts.Regular.size(size: 14)
            self.phoneCodeLabel!.text = "+1"
            view.addSubview(self.phoneCodeLabel!)
        
            self.textField.leftViewMode = UITextField.ViewMode.always
            self.textField.leftView = view
            
            break
        case .Mobile:
            self.textField.keyboardType = .numberPad
            self.textField.textContentType = .telephoneNumber
            let width = self.textField.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: width))
            view.backgroundColor = .clear
          
            self.phoneCodeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: width))
            self.phoneCodeLabel!.font = AppFonts.Regular.size(size: 14)
            self.phoneCodeLabel!.text = "+1"
            view.addSubview(self.phoneCodeLabel!)
        
            self.textField.leftViewMode = UITextField.ViewMode.always
            self.textField.leftView = view
            break
        case .Calendar:
           
            self.textField.keyboardType = .default
            
            self.textField.leftViewMode = UITextField.ViewMode.always
            
            let width = self.textField.bounds.height
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: width))
          
            let imageView = UIImageView(frame: view.bounds)
            imageView.image = UIImage(named: "icon_textfield_calendar")
            imageView.contentMode = .center
            view.addSubview(imageView)
            view.backgroundColor = .clear
            self.textField.leftView = view
            
            self.textField.isUserInteractionEnabled = false
            
            let dropButton = UIButton(frame: CGRect(x: 0, y: 6, width: self.textField.bounds.width, height: self.textField.bounds.height))
            dropButton.addTarget(self, action: #selector(calendarButtonClick), for: .touchUpInside)
            dropButton.backgroundColor = .clear
            self.addSubview(dropButton)
            
            break
        }
    }
    @objc func calendarButtonClick(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            if let calPopupVC = CalendarPopupViewController.storyboardInstance() {
                calPopupVC.modalPresentationStyle = .overCurrentContext
                
                if self.minimumDate != nil {
                    calPopupVC.minimumDate = self.minimumDate
                }
                if self.maximumDate != nil {
                    calPopupVC.maximumDate = self.maximumDate
                }
                
                calPopupVC.completionBlock = { selectedDate in
                    
                    DispatchQueue.main.async {
                        self.textField.text = selectedDate.formate(format: "dd, MMMM, yyyy")
                        self.selectedDate = selectedDate
                        self.showFloatingTitle()
                    }
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController!.present(calPopupVC, animated: false)
            }
        }
    }

    // MARK: - Show Title
    public func showFloatingTitle() {
        self.titleView.isHidden = false
    }
    public func hideFloatingTitle() {
        self.titleView.isHidden = true
    }

    // MARK: - Eye Button Click
    @objc func eyeButtonClick(_ sender: UIButton) {
        self.textField.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    // MARK: - Eye Button Click
    @objc func dropDownButtonClick(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.dropDownClick(textView: self)
        }
    }
    
    
    //MARK: - Initializer
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
      //  Bundle(identifier: "org.cocoapods.SKFloatingTextField")?.loadNibNamed("SKFloatingTextField", owner: self, options: nil)
        let nib = UINib(nibName: "SKFloatingTextField", bundle: nil)
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
        
        
        self.textField.font = AppFonts.Regular.size(size: 14)
        self.borderView.layer.cornerRadius = self.corner_radius
        self.borderView.layer.borderColor = self.border_color.cgColor
        self.borderView.layer.borderWidth = self.border_width
        self.borderView.layer.masksToBounds = true
        
        self.textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        self.textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        self.textField.addTarget(self, action: #selector(textFieldDidChangeSelection), for: .editingChanged)
       
        self.textField.tintColor = .black
        self.textField.delegate = self
        self.hideFloatingTitle()
    }

}
extension PekoFloatingTextFieldView {
    @objc fileprivate func textFieldDidEndEditing() {
        if self.textField.text == "" {
            self.textField.placeholder = self.placeholder.localizeString()
            self.hideFloatingTitle()
        } 
//        else if self.isValidInput {
//            self.errorLabelText = ""
//        }
        
      //  self.borderView.layer.borderColor = self.borderColor?.cgColor
        //self.delegate?.textFieldDidEndEditing?(textField: self)
    }
    @objc fileprivate func textFieldDidBeginEditing() {
        self.showFloatingTitle()
        self.textField.placeholder = ""
      //  self.borderView.layer.borderColor = self.active_color.cgColor
       // }
      //  self.delegate?.textFieldDidBeginEditing?(textField: self)
    }
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
}
extension PekoFloatingTextFieldView:UITextFieldDelegate{
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
