//
//  BankModel.swift
//  Peko
//
//  Created by Hardik Makwana on 11/03/24.
//

import UIKit

struct BankResponseDataModel:Codable {
    
    let data:[BankModel]?
  //  let addresses:[AddressModel]?
}
//struct AddressResponseDataModel2:Codable {
//    let addresses:[AddressModel]?
//}

struct BankModel:Codable {
    let id:Int?
    let accountHolderName:String?
    let accountNumber:String?
    let bankName:String?
   
    let bankAddress:String?
    let iban:String?
    let swiftCode:String?
    let accountType:String?
   
    let destinationIdLean:String?
    let bankIdentifier:String?
   
    let status:CustomInt?
    let is_default:CustomInt?
    
    let createdAt:String?
    let updatedAt:String?
   
    
    enum CodingKeys: String, CodingKey {
        case id // = "success"
        case accountHolderName
        case accountNumber
        case bankName
        
        case bankAddress // = "success"
        case iban
        case swiftCode
        case accountType
        
        case destinationIdLean // = "success"
        case bankIdentifier
      
        case status
        case is_default = "default"
       
        case createdAt
        case updatedAt
    }
}
