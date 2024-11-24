//
//  SubscriptionPaymentValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 08/03/24.
//

import UIKit

struct SubscriptionPaymentValidation {
    
    func ValidateSearch(request: SubscriptionPaymentRequest) -> AppValidationResult
    {
        if(request.companyName!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter company name")
        }
        if(request.domainName!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter domain name")
        }
        if(request.adminEmail!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter admin email")
        }
        if !(request.adminEmail!.isValidEmail)
        {
            return AppValidationResult(success: false, error: "Please enter valid admin email")
        }
//        if(request.address!.isEmpty)
//        {
//            return AppValidationResult(success: false, error: "Please enter address")
//        }
//        if(request.country!.isEmpty)
//        {
//            return AppValidationResult(success: false, error: "Please select country")
//        }
        
        return AppValidationResult(success: true, error: nil)
    }
    
    
}
