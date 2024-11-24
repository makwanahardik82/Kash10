//
//  BeneficiaryValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 18/03/23.
//

import UIKit


struct BeneficiaryValidation {

    func Validate(beneficiaryRequest: BeneficiaryRequest) -> AppValidationResult
    {
        if(beneficiaryRequest.name!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter beneficiary name")
        }
        if(beneficiaryRequest.accountNo!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter beneficiary number")
        }
        return AppValidationResult(success: true, error: nil)
    }
}
