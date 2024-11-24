//
//  AddBankValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 05/04/24.
//

import UIKit

struct AddBankValidation {
    func Validate(request: AddBankRequest) -> AppValidationResult
    {
        if(request.accountHolderName.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter account holder name")
        }
        if(request.accountNumber.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter account number")
        }
        if(request.bankName.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter bank name")
        }
        if(request.bankAddress.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter bank address")
        }
        if(request.ibanNumber.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter IBAN number")
        }
        if(request.ibanNumber.count < 13 || request.ibanNumber.count > 24)
        {
            return AppValidationResult(success: false, error: "IBAN size must be between 13 and 24")
        }
        
        if(request.swiftCode.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter swift code")
        }
        if(request.accountType.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select account type")
        }
        return AppValidationResult(success: true, error: nil)
    }
}
