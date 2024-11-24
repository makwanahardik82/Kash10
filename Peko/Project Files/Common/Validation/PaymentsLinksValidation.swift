//
//  PaymentsLinksValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 21/05/23.
//

import UIKit

struct PaymentsLinksValidation {

    func Validate(request: PaymentsLinksRequest) -> AppValidationResult
    {
        if(request.phoneNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter phone number")
        }
        if(request.name!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter name")
        }
        if(request.amount!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter amount")
        }

        
        if(request.email!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter email")
        }
        if !(request.email?.isValidEmail ?? false) {
            return AppValidationResult(success: false, error: "Please enter valid email")
        }
        
        if(request.note!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter note")
        }
        
//        if(request.createDate!.isEmpty)
//        {
//            return AppValidationResult(success: false, error: "Please select create date")
//        }
        
        if !request.noExpiry {
            if(request.expiryDate!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please select expiry date")
            }
        }
        return AppValidationResult(success: true, error: nil)
        
    }
}
