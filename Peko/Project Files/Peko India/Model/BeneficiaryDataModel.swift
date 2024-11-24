//
//  BeneficiaryModel.swift
//  Peko India
//
//  Created by Hardik Makwana on 25/12/23.
//

import UIKit
struct BeneficiaryDataModel: Codable {
   
    let id:Int?
    let accessKey:String?
    var name:String?
    var phoneNo:String?
    
    var serviceProvider:String?
    var billerId:String?
    var providerCircle:String?
    var accountNo:String?
    
    var isActive:CustomBool?
    
    let createdAt:String?
    let updatedAt:String?
   
    
    let credentialId:CustomInt?
   
    var customerParams:CustomArray?
    
}

struct MobileBeneficiaryDataModel: Codable {
   
    let id:Int?
    let accessKey:String?
    var name:String?
    var phoneNo:String?
    
    var serviceProvider:String?
    var billerId:String?
    var providerCircle:String?
    var accountNo:String?
    
    var isActive:CustomBool?
    
    let createdAt:String?
    let updatedAt:String?
   
    
    let credentialId:CustomInt?
   
    var customerParams:[CustomerParamsModel]?
    
}

struct CustomerParamsModel: Codable {
    
    let value:String?
    var paramName:String?
    
}
struct CustomArray: Codable {
    var value = [CustomerParamsModel]()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
       
        if let x = try? container.decode(CustomerParamsModel.self) {
            self.value.append(x)
            return
        }else if let x = try? container.decode([CustomerParamsModel].self) {
            self.value = x
            return
        }
        
        throw DecodingError.typeMismatch(CustomString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TransactionID"))
    }
}
