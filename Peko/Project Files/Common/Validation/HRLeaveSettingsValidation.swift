//
//  HRLeaveSettingsValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 18/06/24.
//

import UIKit

struct HRLeaveSettingsLeaveValidation {
    
    func Validate(request: HRLeaveSettingsLeaveRequest) -> AppValidationResult
    {
        if(request.annualLeave.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter annual leave")
        }
        if(request.sickLeave.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter sick leave")
        }
        if(request.parentalLeave.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter parental leave")
        }
        if(request.sabbaticalLeave.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter sabbatical leave")
        }
        if(request.HajjAndUmrahLeave.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter religious leave")
        }
        if(request.studyLeave.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter study leave")
        }
        if(request.officialLeavesAndVacations.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter official leaves and vacations")
        }
        if(request.maternityLeave.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter maternity leave")
        }
        if(request.otherPaidLeaves.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter other paid leaves")
        }
        if(request.eligibilityTimePeriod.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter leave eligibility time period")
        }
        return AppValidationResult(success: true, error: nil)
    }
}


struct HRLeaveSettingsValidation {
    
    func Validate(request: HRLeaveSettingsRequest) -> AppValidationResult
    {
        if(request.organizationWorkingdays.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter organization working days")
        }
        if(request.weeklyWorkingDays.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter working days in a week")
        }
        if(request.salaryCycleDay.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter day of the month")
        }
        if(request.payrollStartsFrom == nil)
        {
            return AppValidationResult(success: false, error: "Please select payroll start from")
        }
       
        if(request.hrSignatureBase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select HR signature")
        }
        if(request.companyStampBase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select company stamp")
        }
     
        return AppValidationResult(success: true, error: nil)
    }
}
