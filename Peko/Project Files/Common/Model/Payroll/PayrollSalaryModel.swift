//
//  PayrollSalaryModel.swift
//  Peko
//
//  Created by Hardik Makwana on 14/06/24.
//

import UIKit


struct PayrollSalaryListResponseModel: Codable {
    
    let count:Int?
    let totalPayableSum:Double?
    
    let salaryCycle:PayrollSalaryListCycleModel?
    
    let rows:[PayrollSalaryModel]?
}
struct PayrollSalaryListCycleModel: Codable {
    let salaryCycleStart:String?
    let salaryCycleEnd:String?
    let salaryCycleDays:Int?
}

struct PayrollSalaryModel: Codable {
    let year:Int?
    let month:Int?
    let salaryCycleDays:Int?
    let leaveCount:CustomDouble?
    let leaveDeduction:CustomDouble?
    let attendancePercentage:CustomDouble?
    let totalOtherDeduction:CustomDouble?
    let totalIncentive:CustomDouble?
    let totalBonus:CustomDouble?
    let totalOvertime:CustomDouble?
    let totalPayable:CustomDouble?
    let others:CustomDouble?
    let monthlySalary:CustomDouble?
   
    
    let corporateUser:String?
    let salaryCycleStart:String?
    let salaryCycleEnd:String?
    let message:String?
    let paymentStatus:String?
    let id:String?
   
    let status:Bool?
    let paySlipEmailSent:Bool?
    
    let employee:PayrollEmployeeModel?
     let salaryInformation:PayrollSalaryInformationModel?
    
    let department:PayrollSalaryDepartmentModel?
    
    var star_date:Date {
        get {
            return self.salaryCycleStart!.dateFromISO8601() ?? Date()
        }
    }
    var end_date:Date {
        get {
            return self.salaryCycleEnd!.dateFromISO8601() ?? Date()
        }
    }
    
    
}

struct PayrollSalaryInformationModel: Codable {
    let basicPay:CustomDouble?
    let travelAllowances:CustomDouble?
    let homeAllowances:CustomDouble?
    let medicalAllowances:CustomDouble?
    let otherAllowances:CustomDouble?
    let other:CustomDouble?

   
}

struct PayrollSalaryDepartmentModel: Codable {
    let _id:String?
    let departmentName:String?
}

// MARK: -
struct PayrollSalaryProfileResponseModel: Codable {
    
    let salaryInfo:Int?
    let leaveSummary:Double?
    let employee:PayrollSalaryListCycleModel?
        
}

// MARK: -
struct PayrollSalarySlipResponseModel: Codable {
    let count:Int?
    let totalEmailed:Int?
    let rows:[PayrollSalaryProfileInfoModel]
}

struct PayrollSalaryProfileInfoModel: Codable {
    
    
    let id:String
   // let id:String?
   
    let year:Int?
    let month:Int?
  
    let salaryCycleDays:Int?
    let salaryCycleStart:String?
    let salaryCycleEnd:String?
    
    let leaveCount:CustomDouble?
    let leaveDeduction:CustomDouble?
  
    let attendancePercentage:CustomDouble?
 
    let totalOtherDeduction:CustomDouble?
  
    let totalIncentive:CustomDouble?
    let totalBonus:CustomDouble?
    let totalOvertime:CustomDouble?
    let totalPayable:CustomDouble?
   
    let others:CustomDouble?
    let monthlySalary:CustomDouble?
    
    let corporateUser:String?
    let message:String?
    let paymentStatus:String?
    
    let status:Bool?
    let paySlipEmailSent:Bool?
   
    let salaryInformation:PayrollSalaryInformationModel?
   
    let employee:String?
    
    let department:PayrollSalaryDepartmentModel?
 
    
    var star_date:Date {
        get {
            return self.salaryCycleStart!.dateFromISO8601() ?? Date()
        }
    }
    var end_date:Date {
        get {
            return self.salaryCycleEnd!.dateFromISO8601() ?? Date()
        }
    }
    
    
//    "otherDeductions": [],
//    "incentives": [],
//   "bonus": [],
//
}

