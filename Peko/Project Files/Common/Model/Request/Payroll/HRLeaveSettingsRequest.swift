//
//  HRLeaveSettingsRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 18/06/24.
//

import UIKit

struct HRLeaveSettingsLeaveRequest {
    var annualLeave, sickLeave, parentalLeave, sabbaticalLeave, studyLeave, HajjAndUmrahLeave, maternityLeave, officialLeavesAndVacations, otherPaidLeaves, eligibilityTimePeriod:String
}



struct HRLeaveSettingsRequest {
    var organizationWorkingdays, weeklyWorkingDays, salaryCycleDay, hrName, hrSignatureBase64, companyStampBase64:String
    
    var payrollStartsFrom:Date?
}
