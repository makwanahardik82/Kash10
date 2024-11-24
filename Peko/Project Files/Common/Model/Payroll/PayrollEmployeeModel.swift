//
//  PayrollEmployeeModel.swift
//  Peko
//
//  Created by Hardik Makwana on 27/05/24.
//

import UIKit

struct PayrollEmployeeListResponseModel: Codable {
    
    let count:Int?
    let rows:[PayrollEmployeeModel]?
    
}

struct PayrollEmployeeModel: Codable {
    
    let corporateUser:String?
    let fullName:String?
    let profileImage:String?
    
    let dateOfBirth:String?
    let gender:String?
   
    let mobileNo:String?
    let emergencyNo:String?
    let personalEmail:String?
    let emergencyContactName:String?
    let emergencyContactRelation:String?
    
    let nationality:String?
    let createdAt:String?
    
    let updatedAt:String?
    let id:String?
    
    let isEmployeeDeleted:Bool?
 
    let employeeInformation:PayrollEmployeeInformationModel?
   
    let salaryInformation:PayrollEmployeeSalaryInformationModel?
  
    let bankDetails:PayrollEmployeeBankDetailsModel?
    
}

struct PayrollEmployeeInformationModel: Codable {
    
    let dateOfJoin:String?
    let employeeId:String?
    let designation:String?
    let status:String?
    let jobType:String?
//    let reportingStaff:String?
    let schedule:String?
  
    let workingHours:CustomDouble?
    let probation:Int?
    let workingDays:Int?
 
                        
//    let department:PayrollEmployeeInformationDepartmentModel?
    
}
struct PayrollEmployeeInformationDepartmentModel: Codable {
    
    let departmentName:String?
    let id:String?
}

struct PayrollEmployeeSalaryInformationModel: Codable {
    
    let basicPay:CustomDouble?
    let travelAllowances:CustomDouble?
    let homeAllowances:CustomDouble?
    let medicalAllowances:CustomDouble?
    let otherAllowances:CustomDouble?
    let other:CustomDouble?
    
}
struct PayrollEmployeeBankDetailsModel: Codable {
    
    let accountNumber:String?
    let swiftCode:String?
    let bankName:String?
   
    let ibanNumber:String?
    let beneficiaryName:String?
    let routingCode:String?
    
}


struct EmployeeModel: Codable {
    
    let id:String?
    let label:String?
    let value:String?
    let fullName:String?
    
}

struct EmployeeResponseModel: Codable {
    let employees:[EmployeeModel]?
}


