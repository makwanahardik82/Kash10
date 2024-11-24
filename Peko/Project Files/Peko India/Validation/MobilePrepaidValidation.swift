//
//  MobilePrepaidValidation.swift
//  Peko India
//
//  Created by Hardik Makwana on 19/12/23.
//

import UIKit

struct MobilePrepaidValidation {
    
    func Validate(request: MobilePrepaidRequest) -> AppValidationResult
    {
        if(request.mobileNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter mobile number")
        }
        if(request.mobileNumber!.count != 10)
        {
            return AppValidationResult(success: false, error: "Please enter valid mobile number")
        }
        
        if !request.isPostpaid! {
            if(request.location!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please select state")
            }
        }
        if(request.serviceProvider!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select operator")
        }
        return AppValidationResult(success: true, error: nil)
    }
}


