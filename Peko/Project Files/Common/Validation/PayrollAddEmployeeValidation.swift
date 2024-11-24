//
//  PayrollAddEmployeeValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 21/06/24.
//

import UIKit


struct PayrollAddEmployeeValidation {
    
    // MARK: Bank Details
    func Validate(request: PayrolAddEmployeeBankInfoRequest) -> AppValidationResult
    {
        if(request.beneficiaryName.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter beneficiary name")
        }
        if(request.accountNumber.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter account number")
        }
        if(request.bankName.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter bank name")
        }
        if(request.swiftCode.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter swift code")
        }
        if(request.IBANNumber.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter IBAN number")
        }
        if(request.routingCode.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter routing code")
        }
        return AppValidationResult(success: true, error: nil)
    }
    
    // MARK: - Document
    func Validate(documentRequest: PayrolAddEmployeeOfficialDocumentsRequest) -> AppValidationResult
    {
        if(documentRequest.govtEmpContractBase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select government employee contract document")
        }
        if(documentRequest.govtEmpContractExiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select government employee contract expiry date")
        }
      // empVisaBase64
        if(documentRequest.empVisaBase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select employee visa document")
        }
        if(documentRequest.empVisaExiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select employee visa expiry date")
        }
        // offerLetterBase64
        if(documentRequest.offerLetterBase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select employee offer letter document")
        }
        if(documentRequest.offerLetterExiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select employee offer letter expiry date")
        }
      // NDABase64
        if(documentRequest.NDABase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select NDA document")
        }
        if(documentRequest.NDAExiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select NDA expiry date")
        }
        // passportBase64
        if(documentRequest.passportBase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select password document")
        }
        if(documentRequest.passportExiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select password expiry date")
        }
      // healthInsuranceBase64
        if(documentRequest.healthInsuranceBase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select health insurance document")
        }
        if(documentRequest.healthInsuranceExiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select health insurance expiry date")
        }
      // labourCardBase64
        if(documentRequest.labourCardBase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select labour card document")
        }
        if(documentRequest.labourCardExiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select labour card  expiry date")
        }
      // UAEResidentIDBase64
        if(documentRequest.UAEResidentIDBase64.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select UAE resident ID document")
        }
        if(documentRequest.UAEResidentIDExiryDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select UAE resident ID expiry date")
        }
       
        return AppValidationResult(success: true, error: nil)
    }
    
    
    // MARK: Salary Details
    func Validate(salaryRequest: PayrolAddEmployeeSalaryInfoRequest) -> AppValidationResult
    {
        if(salaryRequest.monthlyBasic.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter monthly basic")
        }
        if(salaryRequest.homeAllowances.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter home allowances")
        }
        if(salaryRequest.travelAllowances.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter travel allowances")
        }
        if(salaryRequest.medicalAllowances.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter medical allowances")
        }
        if(salaryRequest.otherAllowances.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter other allowances")
        }
        
        return AppValidationResult(success: true, error: nil)
    }
    
    // MARK: EMP INFO Details
    func Validate(empRequest: PayrolAddEmployeeInfoRequest) -> AppValidationResult
    {
        
        if(empRequest.joinDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select join date")
        }
        
        if(empRequest.employeeID.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter employee ID")
        }
        if(empRequest.department.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select department")
        }
        if(empRequest.designation.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter designation")
        }
        if(empRequest.workingDays.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter working days")
        }
        if(empRequest.startTimeSchedule.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select start time")
        }
        if(empRequest.endTimeSchedule.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select end time")
        }
        if(empRequest.employeeType.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select employee type")
        }
        if(empRequest.employeeStatus.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter employee status")
        }
        if(empRequest.reportingStaff.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter reporting staff")
        }
        
        return AppValidationResult(success: true, error: nil)
    }
}
