//
//  AddressModel.swift
//  Peko
//
//  Created by Hardik Makwana on 08/03/24.
//

import UIKit

struct AddressResponseDataModel:Codable {
    
    let data:[AddressModel]?
    let addressDetails:[AddressModel]?
  //  let addresses:[AddressModel]?
}
struct AddressResponseDataModel2:Codable {
    let addresses:[AddressModel]?
}

struct AddressModel:Codable {
    let id:Int?
    let name:String?
    let nickname:String?
    let department:String?
   
    let city:String?
    let state:String?
    let country:String?
    let addressLine1:String?
    let addressLine2:String?
    let phoneNumber:String?
    
    let email:String?
    let countryCode:String?
    let zipCode:String?
    
    let is_default:CustomBool?
    let isReceiver:CustomBool?
    let addressType:CustomString?
    
    enum CodingKeys: String, CodingKey {
        case id // = "success"
        case name
        case nickname
        case department
        
        case city // = "success"
        case country
        case state
        case addressLine1
        case addressLine2
        case phoneNumber
        
        case email // = "success"
        case countryCode
        case zipCode
        
        case is_default = "default"
        case isReceiver
        case addressType
    }
}
