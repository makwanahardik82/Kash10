//
//  PayrollLeaveModel.swift
//  Peko
//
//  Created by Hardik Makwana on 12/06/24.
//

import UIKit

struct PayrollLeaveModel: Codable {
    
    let corporateUser:String?
    let start:String?
    let end:String?
   
    let leaveCount:Int?
    
    let typeOfLeave:String?
    let leaveSupportingDocs:String?
    let createdAt:String?
    let updatedAt:String?
    let id:String?
  
    let employee:PayrollEmployeeModel?
    
    var start_date:Date {
        get {
            return self.start!.dateFromISO8601() ?? Date()
        }
    }
    var end_date:Date {
        get {
            return self.end!.dateFromISO8601() ?? Date()
        }
    }
}

struct PayrollLeaveResponseModel: Codable {
    
    let totalCount:Int?
    let leaveData:[PayrollLeaveModel]?
    
}
// MARK: -
struct PayrollLeaveActionModel: Codable {
    
    let corporateUser:String?
    let start:String?
    let end:String?
   
    let leaveCount:Int?
    
    let typeOfLeave:String?
    let leaveSupportingDocs:String?
    let createdAt:String?
    let updatedAt:String?
    let id:String?
  
    let employee:String?
    
}

struct PayrollAvailableLeaveResponseModel: Codable {
    
    let availableLeaves:[PayrollAvailableLeaveModel]?
    
}

struct PayrollAvailableLeaveModel: Codable {
    
    let value:String?
    let label:String?
    let count:CustomString?
    
}


