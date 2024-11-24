//
//  PayrollDashboardDetailModel.swift
//  Peko
//
//  Created by Hardik Makwana on 12/06/24.
//

import UIKit


struct PayrollDashboardDetailModel: Codable {
    
    let totalSalary:CustomDouble?
    let activeEmployees:CustomDouble?
    let nextMonthSalary:CustomDouble?
    let lastMonthSalary:CustomDouble?
   
//    let upcomingActivities:StriCustomDoubleng?
//    let corporateUser:CustomDouble?
    
}

struct PayrollDashboardChartModel: Codable {
    
    let id:Int?
    let month:String?
    let totalSalary:CustomDouble?
}
struct PayrollDashboardChartResponseModel: Codable {
    let chartData:[PayrollDashboardChartModel]?
}
