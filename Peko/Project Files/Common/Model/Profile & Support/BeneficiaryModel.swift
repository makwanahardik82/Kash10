//
//  BeneficiaryModel.swift
//  Peko
//
//  Created by Hardik Makwana on 16/03/23.
//

import UIKit

struct BeneficiaryResponseDataModel: Codable {
    let data:[BeneficiaryModel]?
}
struct BeneficiaryModel: Codable {
    let id:Int?
    let credentialId:CustomInt?
    var name:String?
    var accountNo:String?
    let accessKey:String?
    var isActive:CustomBool?
    let optional1:String?
    
    let createdAt:String?
    let updatedAt:String?
    
    let serviceOperatorId:Int?
    let serviceOperator:ServiceOperatorModel?
    
}


struct ServiceOperatorModel: Codable {
    var serviceProvider:String?
    var serviceImage:String?
    var id:Int?
}
