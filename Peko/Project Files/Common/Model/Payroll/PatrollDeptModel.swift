//
//  PatrollDeptModel.swift
//  Peko
//
//  Created by Hardik Makwana on 10/06/24.
//

import UIKit

struct PayrollDeptModel: Codable {
    
    let id:String?
    let departmentName:String?
    let departmentCode:String?
    let description:String?
    let createdAt:String?
    let updatedAt:String?
    let corporateUser:String?
    
}

struct PayrollDeptListResponseModel: Codable {
    
    let totalCount:Int?
    let departmentData:[PayrollDeptModel]?
    
}
struct PayrollDeptShortDetailModel: Codable {
    
    let _id:String?
    let departmentName:String?
  
}
