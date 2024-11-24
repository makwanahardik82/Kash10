//
//  UITextField+Extension.swift
//  Peko
//
//  Created by Hardik Makwana on 28/01/23.
//

import UIKit

extension UITextField {
    func decimalNumberValidation(number: String) -> Bool
    {
        let countdots = (self.text!.components(separatedBy: ".").count) - 1
        if countdots > 0 && number == "."
        {
            return false
        }
        
        let countComma = (self.text!.components(separatedBy: ",").count) - 1
        if countComma > 0 && number == ","
        {
            return false
        }
        
        let allowedCharacters = CharacterSet(charactersIn:",.0123456789")
        let characterSet = CharacterSet(charactersIn: number)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    func numberValidation(number: String) -> Bool
    {
        let allowedCharacters = CharacterSet(charactersIn:"0123456789")
        let characterSet = CharacterSet(charactersIn: number)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
