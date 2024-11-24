//
//  WorkspaceValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 12/03/24.
//

import UIKit

struct WorkspaceValidation {
    
    func Validate(request: WorkspaceRequest) -> AppValidationResult
    {
        if(request.licenseType!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select license type")
        }
        if(request.companyName!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter company name")
        }
        if(request.expiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select expiry date")
        }
        if(request.tradeLicenseBase64!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please upload trade license copy")
        }
        if(request.ownerVisaBase64!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please upload visa copy")
        }
        
        return AppValidationResult(success: true, error: nil)
    }
    
    
}



