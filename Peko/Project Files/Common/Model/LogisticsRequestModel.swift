//
//  LogisticsRequestModel.swift
//  Peko
//
//  Created by Hardik Makwana on 13/09/23.
//

import UIKit


struct LogisticsRequestModel {
    
    var senderDetails:LogisticsAddressDetailModel?
    var receiverDetails:LogisticsAddressDetailModel?
    
}
struct LogisticsAddressDetailModel:Codable {
    
    let name:String?
    let country:String?
    let city:String?
    let buldingName:String?
    let email:String?
    let mobileNumber:String?
   
    let countryCode:String?
    let pinCode:String?
    
    var addressLine1:String? // = ""
  //  var addressLine2:String? // = ""
    
}


struct LogisticsShipmentDetailModel:Codable {

    let content:String?
    let noOfPieces:String?
    let weight:String?
    let sheduleDate:Date?
    let serviceType:String?
   
}
struct LogisticsShipmentServiceModel:Codable {
    
   
    var serviceTypeCode:String?
    var isSheild:Bool?
    var sheildAmount:String?
    var isCashOnDelivery:String?
    var cashOnDeliveryAmount:String?
    
}
