//
//  UtilityAddBeneficiaryValidation.swift
//  Peko India
//
//  Created by Hardik Makwana on 28/12/23.
//

import UIKit


struct UtilityAddBeneficiaryValidation {
    
    func Validate(request: UtilityAddBeneficiaryRequest) -> AppValidationResult
    {
        if(request.name!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter beneficiary name")
        }
        if objUtilityBillsManager!.selectedUtilityBillType == .Electricity {
            if(request.state!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please select state")
            }
        }
        
        if(request.serviceProvider!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select service provider")
        }
        
        if(request.consumerNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter consumer number")
        }
       
        return AppValidationResult(success: true, error: nil)
    }
}
