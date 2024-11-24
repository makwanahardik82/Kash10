//
//  AttributedString+Extension.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit

extension NSMutableAttributedString {
    
    /*
    @discardableResult func paragraphStyle(_ text:String,_ font:UIFont,_ lineSpacing:CGFloat,_ alignment:NSTextAlignment = .left) -> NSMutableAttributedString {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        paraStyle.alignment = alignment
        
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle:paraStyle,
        NSAttributedString.Key.font:font as Any]
        
        let attString = NSAttributedString(string: text, attributes: attrs)
        append(attString)
        
        return self
    }
    */
    
    @discardableResult func color(_ color: UIColor, _ text:String, font:UIFont = UIFont.systemFont(ofSize: 14), _ lineSpacing:CGFloat = 2, _ alignment:NSTextAlignment = .left) -> NSMutableAttributedString {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        paraStyle.alignment = alignment
        
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor:color,
            NSAttributedString.Key.font:font as Any,
            NSAttributedString.Key.paragraphStyle:paraStyle
        ]
        
        let attString = NSAttributedString(string: text, attributes: attrs)
        append(attString)
        
        return self
    }
    
    @discardableResult func underline(_ color: UIColor, _ text:String, font:UIFont = UIFont.systemFont(ofSize: 14), lineSpacing:CGFloat = 0) -> NSMutableAttributedString {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
      //  paraStyle.alignment = alignment
        
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor:color,
            NSAttributedString.Key.font:font as Any,
            NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.paragraphStyle:paraStyle
        ]
        let attString = NSAttributedString(string: text, attributes: attrs)
        append(attString)
    
        return self
    }
    
    @discardableResult func strike(_ color: UIColor, _ text:String, font:UIFont = UIFont.systemFont(ofSize: 14), _ lineSpacing:CGFloat = 2, _ alignment:NSTextAlignment = .left) -> NSMutableAttributedString {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        paraStyle.alignment = alignment
        
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor:color,
            NSAttributedString.Key.font:font as Any,
            NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.paragraphStyle:paraStyle
        ]
        let attString = NSAttributedString(string: text, attributes: attrs)
        append(attString)
    
        return self
    }
    
    // MARK: -
    @discardableResult func image(_ image: UIImage, lineSpacing:CGFloat = 0) -> NSMutableAttributedString {
        
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = image
        image1Attachment.bounds = CGRect(x: 0, y: 0, width: 24, height: 24)
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        append(image1String)
        
        return self
    }
    
    @discardableResult func subscriptString(_ color: UIColor, _subscriptString:String, font:UIFont = UIFont.systemFont(ofSize: 14), _ lineSpacing:CGFloat = 2, _ alignment:NSTextAlignment = .left) -> NSMutableAttributedString {
        
        /*
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        paraStyle.alignment = alignment
        
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor:color,
            NSAttributedString.Key.font:font as Any,
            NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.paragraphStyle:paraStyle
        ]
         */
       
        let baselineOffset = NSNumber(value: -Double(font.pointSize) * 0.15)

        let subscriptAttributes: [NSAttributedString.Key: Any] = [
            .font: font.withSize(font.pointSize * 0.7),
            .baselineOffset: baselineOffset,
            NSAttributedString.Key.foregroundColor:color
        ] //.merging(attributes) { $0 }
  
        let attString = NSAttributedString(string: _subscriptString, attributes: subscriptAttributes)
        append(attString)
    
        return self
    }
    
    
//    let strokeEffect: [NSAttributedStringKey : Any] = [
//            NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue,
//            NSAttributedStringKey.strikethroughColor: UIColor.red,
//        ]
//
//       let strokeString = NSAttributedString(string: "text", attributes: strokeEffect)
//
}

