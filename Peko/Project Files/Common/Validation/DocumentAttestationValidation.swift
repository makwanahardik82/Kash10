//
//  DocumentAttestationValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 06/05/24.
//

import UIKit

struct DocumentAttestationValidation {
    
    func Validate(request: DocumentAttestationRequest) -> AppValidationResult
    {
        if(request.issueCountry.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select issue country")
        }
        if(request.docType.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select type of document")
        }
        if(request.submissionCountry.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select submission country")
        }
        if(request.passportURL.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select passport")
        }
        return AppValidationResult(success: true, error: nil)
    }
    
    
    func Validate(request: DocumentAttestationAddress) -> AppValidationResult
    {
        if(request.name.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter sender name")
        }
        if(request.country.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select country")
        }
        if(request.city.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter city")
        }
        if(request.building.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter address")
        }
        if(request.zipCode.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter zip code")
        }
        if(request.mobileNumber.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter mobile number")
        }
        return AppValidationResult(success: true, error: nil)
    }
}



//struct DocumentAttestationAddress {
   // var name, country, city, building, zipCode, mobileNumber:String
//}
