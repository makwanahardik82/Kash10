//
//  PayrolAddEmployeePersonalInfoRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 18/06/24.
//

import UIKit

struct PayrolAddEmployeePersonalInfoRequest {
    var fullName, gender, phoneNumber, email, emergencyContactNumber, emergencyContactName, emergencyContactRelation, nationality:String
   
    var dateOfBirth:Date?
}

struct PayrolAddEmployeeInfoRequest {
    var employeeID, department, designation, workingDays, startTimeSchedule, endTimeSchedule, employeeType, employeeStatus, reportingStaff, employeeGrade, departmentID, reportingStaffID:String
   
    var joinDate:Date?
}


struct PayrolAddEmployeeSalaryInfoRequest {
    var monthlyBasic, homeAllowances, travelAllowances, medicalAllowances, otherAllowances:String
   
}

struct PayrolAddEmployeeOfficialDocumentsRequest {
    var govtEmpContractBase64, empVisaBase64, offerLetterBase64, NDABase64, passportBase64, healthInsuranceBase64, labourCardBase64, UAEResidentIDBase64:String
   
    var govtEmpContractExiryDate, empVisaExiryDate, offerLetterExiryDate, NDAExiryDate, passportExiryDate, healthInsuranceExiryDate, labourCardExiryDate, UAEResidentIDExiryDate:Date?
   
}


struct PayrolAddEmployeeBankInfoRequest {
    var beneficiaryName, accountNumber, bankName, swiftCode, IBANNumber, routingCode:String
   
}
