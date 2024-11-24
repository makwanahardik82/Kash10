//
//  PayrollAddLeaveValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 13/06/24.
//

import UIKit

struct PayrollAddLeaveValidation {
    
    func Validate(request: PayrollAddLeaveRequest) -> AppValidationResult
    {
        if(request.empName.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select employee name")
        }
        if(request.typeLeave.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select type of leave")
        }
        if(request.duration.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter duration")
        }
       
        if(request.startDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select start date")
        }
        if(request.endDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select end date")
        }
        return AppValidationResult(success: true, error: nil)
    }
}
