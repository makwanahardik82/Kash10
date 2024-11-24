//
//  PayrollDashboardSettingsModel.swift
//  Peko
//
//  Created by Hardik Makwana on 27/05/24.
//

import UIKit

struct PayrollDashboardSettingsModel: Codable {
    
    let departmentAndEmployees:Bool?
    let holidays:Bool?
    let hrSettings:Bool?
    let progress:String?
    
}


struct PayrollHRSettingsModel: Codable {
    
    let officialDocuments:PayrollHRSettingsOfficialDocumentsModel?
    let payrollSettings:PayrollHRSettingsPayrollSettingsModel?
    let isFreeZoneCompany:Bool?
    
    
}

struct PayrollHRSettingsLeaveResponseModel: Codable {
    
    let leaveSettings:PayrollHRSettingsLeaveModel?
}
struct PayrollHRSettingsLeaveModel: Codable {
 
    let annualLeave:CustomInt?
    let sickLeave:CustomInt?
    let parentalLeave:CustomInt?
    let sabbaticalLeave:CustomInt?
    let studyLeave:CustomInt?
    let HajjAndUmrahLeave:CustomInt?
    let maternityLeave:CustomInt?
    let officialLeavesAndVacations:CustomInt?
    let otherPaidLeaves:CustomInt?
    let eligibilityTimePeriod:CustomInt?
   
}

struct PayrollHRSettingsOfficialDocumentsModel: Codable {
    
    let hrManagerName:String?
    let hrManagerSignature:String?
    let companyOfficialStamp:String?
    
}

struct PayrollHRSettingsPayrollSettingsModel: Codable {
    
    let organizationWorkingDays:Int?
    let salaryCycleDay:Int?
    
    let payrollStartsFrom:String?
    let isEditable:Bool?
    
    let selectedWeekdaysCount:[Int]?
    
    var payrollStartsFromDate:Date {
        get {
            return self.payrollStartsFrom!.dateFromISO8601() ?? Date()
        }
    }
    
}



