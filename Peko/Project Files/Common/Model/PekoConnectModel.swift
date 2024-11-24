//
//  PekoConnectModel.swift
//  Peko
//
//  Created by Hardik Makwana on 22/05/23.
//

import UIKit

struct PekoConnectResponseDataModel: Codable {
    let data:[PekoConnectModel]?
}

struct PekoConnectDetailResponseDataModel: Codable {
    let data:PekoConnectModel?
}

struct PekoConnectModel: Codable {
    
    let id:Int?
    
    let serviceProvider:String?
    let tagline:String?
    let rewards:String?
    let logo:String?
    
    let address:String?
    let category:String?
    let description:String?
    let offerings:String?
    let email:String?
    let website:String?
    let mobileNo:String?
    let services:[String]?
   
}
  
