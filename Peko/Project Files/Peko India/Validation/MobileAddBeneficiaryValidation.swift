//
//  MobileAddBeneficiaryValidation.swift
//  Peko India
//
//  Created by Hardik Makwana on 26/12/23.
//

import UIKit


struct MobileAddBeneficiaryValidation {
    
    func Validate(request: MobileAddBeneficiaryRequest) -> AppValidationResult
    {
        if(request.name!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter name")
        }
        if(request.serviceProvider!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select operator")
        }
        if(request.mobileNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter mobile number")
        }
        if(request.mobileNumber!.count != 10)
        {
            return AppValidationResult(success: false, error: "Please enter valid mobile number")
        }
        
        return AppValidationResult(success: true, error: nil)
    }
}
