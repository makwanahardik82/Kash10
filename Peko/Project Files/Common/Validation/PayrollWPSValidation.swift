//
//  PayrollWPSValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 18/06/24.
//

import UIKit


struct PayrollWPSValidation {
    
    func Validate(request: PayrollWPSRequest) -> AppValidationResult
    {
        if(request.employerId.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter employer ID")
        }
        if(request.routingCode.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter routing code")
        }
        if(request.employerReference.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter employer reference")
        }
        return AppValidationResult(success: true, error: nil)
    }
}
