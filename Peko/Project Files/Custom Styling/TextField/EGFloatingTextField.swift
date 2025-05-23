
import UIKit
import Foundation
import PureLayout


public enum EGFloatingTextFieldValidationType {
    case Email
    case Number
}

public class EGFloatingTextField: UITextField {
    
    
 //   private typealias EGFloatingTextFieldValidationBlock = ((_ text:String,inout _ message:String)-> Bool)?
    
    public var validationType : EGFloatingTextFieldValidationType!
    
    
//    private var emailValidationBlock  : EGFloatingTextFieldValidationBlock
//    private var numberValidationBlock : EGFloatingTextFieldValidationBlock
    
    
    let kDefaultInactiveColor = UIColor(white: CGFloat(0), alpha: CGFloat(0.54))
    let kDefaultActiveColor = UIColor.blue
    let kDefaultErrorColor = UIColor.red
    let kDefaultLineHeight = CGFloat(22)
    let kDefaultLabelTextColor = UIColor(white: CGFloat(0), alpha: CGFloat(0.54))
    
    
    public var floatingLabel : Bool = true
    var label : UILabel!
    var labelFont : UIFont!
    var labelTextColor : UIColor!
    var activeBorder : UIView!
    var floating : Bool!
    var active : Bool!
    var hasError : Bool!
    var errorMessage : String!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit(){
        /*
        self.emailValidationBlock = ({(text:String, inout message: String) -> Bool in
            var emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            
            var emailTest = NSPredicate(format:"SELF MATCHES %@" , emailRegex)
            
            var  isValid = emailTest.evaluateWithObject(text)
            if !isValid {
                message = "Invalid Email Address"
            }
            return isValid;
        })
        self.numberValidationBlock = ({(text:String,inout message: String) -> Bool in
            var numRegex = "[0-9.+-]+";
            var numTest = NSPredicate(format:"SELF MATCHES %@" , numRegex)
            
            var isValid =  numTest.evaluateWithObject(text)
            if !isValid {
                message = "Invalid Number"
            }
            return isValid;
            
        })
        */
        self.floating = false
        self.hasError = false
       
        self.labelTextColor = kDefaultLabelTextColor
        self.label = UILabel(frame: CGRectZero)
        self.label.font = self.labelFont
        self.label.textColor = self.labelTextColor
        self.label.textAlignment = NSTextAlignment.left
        self.label.numberOfLines = 1
        self.label.layer.masksToBounds = false
        self.addSubview(self.label)
        
        
        self.activeBorder = UIView(frame: CGRectZero)
        self.activeBorder.backgroundColor = kDefaultActiveColor
        self.activeBorder.layer.opacity = 0
        self.addSubview(self.activeBorder)
        
        self.label.autoAlignAxis(.horizontal, toSameAxisOf: self)
        self.label.autoPinEdge(.left, to: .left, of: self)
        self.label.autoMatch(.width, to: .width, of: self)
        self.label.autoMatch(.height, to: .height, of: self)
       
        /*
        self.activeBorder.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: self)
        self.activeBorder.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self)
        self.activeBorder.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self)
        self.activeBorder.autoSetDimension(ALDimension.Height, toSize: 2)
       */
      //  NSNotificationCenter.defaultCenter.addObserver(self, selector: Selector("textDidChange:"), name: UITextField.textDidChangeNotification, object: self)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notif: )), name: UITextField.textDidChangeNotification, object: self)
        
         
        
    }
    public func setPlaceHolder(placeholder:String){
        self.label.text = placeholder
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        var flag:Bool = super.becomeFirstResponder()
        
        if flag {
            
            if self.floatingLabel {
                
                if !self.floating! || self.text!.isEmpty {
                    self.floatLabelToTop()
                    self.floating = true
                }
            } else {
                self.label.textColor = kDefaultActiveColor
                self.label.layer.opacity = 0
            }
            self.showActiveBorder()
        }
        
        self.active=flag
        return flag
    }
    override public func resignFirstResponder() -> Bool {
        
        var flag:Bool = super.resignFirstResponder()
        
        if flag {
            
            if self.floatingLabel {
                
                if self.floating! && self.text!.isEmpty {
                    self.animateLabelBack()
                    self.floating = false
                }
            } else {
                if self.text!.isEmpty {
                    self.label.layer.opacity = 1
                }
            }
            self.label.textColor = kDefaultInactiveColor
            self.showInactiveBorder()
            self.validate()
        }
        self.active = flag
        return flag
        
    }
    
    /*
    override public func drawRect(rect: CGRect){
        super.drawRect(rect)
        
        var borderColor = self.hasError! ? kDefaultErrorColor : kDefaultInactiveColor
        
        var textRect = self.textRectForBounds(rect)
        var context = UIGraphicsGetCurrentContext()
        var borderlines : [CGPoint] = [CGPointMake(0, CGRectGetHeight(textRect) - 1),
            CGPointMake(CGRectGetWidth(textRect), CGRectGetHeight(textRect) - 1)]
        
        if  self.enabled  {
            
            CGContextBeginPath(context);
            CGContextAddLines(context, borderlines, 2);
            CGContextSetLineWidth(context, 1.0);
            CGContextSetStrokeColorWithColor(context, borderColorborderColor.CGColor);
            CGContextStrokePath(context);
            
        } else {
            
            CGContextBeginPath(context);
            CGContextAddLines(context, borderlines, 2);
            CGContextSetLineWidth(context, 1.0);
            var  dashPattern : [CGFloat]  = [2, 4]
            CGContextSetLineDash(context, 0, dashPattern, 2);
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextStrokePath(context);
            
        }
    }
    */
    @objc func textDidChange(notif: NSNotification){
        self.validate()
    }
    
    func floatLabelToTop() {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.label.textColor = self.kDefaultActiveColor
        }
        
        var anim2 = CABasicAnimation(keyPath: "transform")
        var fromTransform = CATransform3DMakeScale(CGFloat(1.0), CGFloat(1.0), CGFloat(1))
        var toTransform = CATransform3DMakeScale(CGFloat(0.5), CGFloat(0.5), CGFloat(1))
        toTransform = CATransform3DTranslate(toTransform, -CGRectGetWidth(self.label.frame)/2, -CGRectGetHeight(self.label.frame), 0)
        anim2.fromValue = NSValue(caTransform3D: fromTransform)
        anim2.toValue = NSValue(caTransform3D: toTransform)
        anim2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        var animGroup = CAAnimationGroup()
        animGroup.animations = [anim2]
        animGroup.duration = 0.3
        animGroup.fillMode = CAMediaTimingFillMode.forwards;
        animGroup.isRemovedOnCompletion = false;
        self.label.layer.add(animGroup, forKey: "_floatingLabel")
        self.clipsToBounds = false
        CATransaction.commit()
    }
    func showActiveBorder() {
        
        self.activeBorder.layer.transform = CATransform3DMakeScale(CGFloat(0.01), CGFloat(1.0), 1)
        self.activeBorder.layer.opacity = 1
        CATransaction.begin()
        self.activeBorder.layer.transform = CATransform3DMakeScale(CGFloat(0.01), CGFloat(1.0), 1)
        var anim2 = CABasicAnimation(keyPath: "transform")
        var fromTransform = CATransform3DMakeScale(CGFloat(0.01), CGFloat(1.0), 1)
        var toTransform = CATransform3DMakeScale(CGFloat(1.0), CGFloat(1.0), 1)
        anim2.fromValue = NSValue(caTransform3D: fromTransform)
        anim2.toValue = NSValue(caTransform3D: toTransform)
        anim2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        anim2.fillMode = CAMediaTimingFillMode.forwards
        anim2.isRemovedOnCompletion = false
        self.activeBorder.layer.add(anim2, forKey: "_activeBorder")
        CATransaction.commit()
    }
    
    func animateLabelBack() {
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.label.textColor = self.kDefaultInactiveColor
        }
        
        var anim2 = CABasicAnimation(keyPath: "transform")
        var fromTransform = CATransform3DMakeScale(0.5, 0.5, 1)
        fromTransform = CATransform3DTranslate(fromTransform, -CGRectGetWidth(self.label.frame)/2, -CGRectGetHeight(self.label.frame), 0);
        var toTransform = CATransform3DMakeScale(1.0, 1.0, 1)
        anim2.fromValue = NSValue(caTransform3D: fromTransform)
        anim2.toValue = NSValue(caTransform3D: toTransform)
        anim2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        var animGroup = CAAnimationGroup()
        animGroup.animations = [anim2]
        animGroup.duration = 0.3
        animGroup.fillMode = CAMediaTimingFillMode.forwards;
        animGroup.isRemovedOnCompletion = false;
        
        self.label.layer.add(animGroup, forKey: "_animateLabelBack")
        CATransaction.commit()
    }
    func showInactiveBorder() {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.activeBorder.layer.opacity = 0
        }
        var anim2 = CABasicAnimation(keyPath: "transform")
        var fromTransform = CATransform3DMakeScale(1.0, 1.0, 1)
        var toTransform = CATransform3DMakeScale(0.01, 1.0, 1)
        anim2.fromValue = NSValue(caTransform3D: fromTransform)
        anim2.toValue = NSValue(caTransform3D: toTransform)
        anim2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        anim2.fillMode = CAMediaTimingFillMode.forwards
        anim2.isRemovedOnCompletion = false
        self.activeBorder.layer.add(anim2, forKey: "_activeBorder")
        CATransaction.commit()
    }
    
    func performValidation(isValid:Bool,message:String){
        if !isValid {
            self.hasError = true
            self.errorMessage = message
            self.labelTextColor = kDefaultErrorColor
            self.activeBorder.backgroundColor = kDefaultErrorColor
            self.setNeedsDisplay()
        } else {
            self.hasError = false
            self.errorMessage = nil
            self.labelTextColor = kDefaultActiveColor
            self.activeBorder.backgroundColor = kDefaultActiveColor
            self.setNeedsDisplay()
        }
    }
    
    func validate(){
        
        if self.validationType != nil {
            var message : String = ""
            /*
            if self.validationType! == .Email {
                
                var isValid = self.emailValidationBlock(text: self.text, message: &message)
                
                performValidation(isValid: isValid,message: message)
                
            } else {
                var isValid = self.numberValidationBlock(text: self.text, message: &message)
                
                performValidation(isValid: isValid,message: message)
            }
            */
        }
    }
    
    
}

extension EGFloatingTextField {
    
}
