//
//  GiftCardValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 14/05/23.
//

import UIKit

struct GiftCardValidation {

    func Validate(request: GiftCardRequest) -> AppValidationResult
    {
        if(request.firstName!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter recipient first name")
        }
//        if(request.lastName!.isEmpty)
//        {
//            return AppValidationResult(success: false, error: "Please enter recipient last name")
//        }
//        if(request.gender!.isEmpty)
//        {
//            return AppValidationResult(success: false, error: "Please select gender")
//        }
        
        if(request.email!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter recipient email")
        }
        if !(request.email?.isValidEmail ?? false) {
            return AppValidationResult(success: false, error: "Please enter valid recipient email")
        }
        
        
        if(request.mobileNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter recipient mobile number")
        }
       
       /*
        if(request.poBox!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter recipient po box")
        }
        if(request.senderName!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter sender name")
        }
        
        if(request.senderPhone!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter sender mobile number")
        }
        */
//        if !(request.senderEmail?.isValidEmail ?? false) {
//            return AppValidationResult(success: false, error: "Please enter valid sender email")
//        }
        
        if(request.message!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter message")
        }
        return AppValidationResult(success: true, error: nil)
     
    }
}
