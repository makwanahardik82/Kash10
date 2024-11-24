//
//  AddAddressValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 02/04/24.
//

import UIKit


struct AddAddressValidation {
    func Validate(request: AddressRequest) -> AppValidationResult
    {
        if(request.fullName.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter full name")
        }
        if(request.addressLine1.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter address line 1")
        }
        if(request.addressLine2.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter address line 2")
        }
        if(request.phoneNumber.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter phone number")
        }
        if(request.addressType.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select address type")
        }
        return AppValidationResult(success: true, error: nil)
    }
}
