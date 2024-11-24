//
//  PayrollAddLeaveRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 13/06/24.
//

import UIKit


struct PayrollAddLeaveRequest {
    var empId, empName, typeLeave, duration:String
    var fileBase64:String?
    var startDate, endDate:Date?
}
