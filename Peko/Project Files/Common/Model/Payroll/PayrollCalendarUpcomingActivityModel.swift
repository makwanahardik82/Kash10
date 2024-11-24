//
//  PayrollCalendarUpcomingActivityModel.swift
//  Peko
//
//  Created by Hardik Makwana on 19/06/24.
//

import UIKit


struct PayrollCalendarUpcomingActivityResponseModel: Codable {
    let upcomingActivities:[PayrollCalendarUpcomingActivityModel]?
}

struct PayrollCalendarUpcomingActivityModel: Codable {
    let title:String?
    let id:String?
    let fullName:String?
    
    let start:String?
    let end:String?
    let activityType:String?
    
    var star_date:Date {
        get {
            return self.start!.dateFromISO8601() ?? Date()
        }
    }
}
