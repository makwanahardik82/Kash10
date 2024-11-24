//
//  PayrollDepartmentValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 10/06/24.
//

import UIKit


struct PayrollDepartmentValidation {
    
    func Validate(request: PayrollAddDepartmentRequest) -> AppValidationResult
    {
        if(request.deptName.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter department name")
        }
        if(request.deptCode.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter department code")
        }
        if(request.deptDescription.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter description")
        }
       
        return AppValidationResult(success: true, error: nil)
    }
    
}
