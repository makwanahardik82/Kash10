//
//  LogisticsCalculateRateResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 23/09/23.
//

import UIKit

struct LogisticsCalculateRateResponseModel: Codable {

   // let Transaction:Int?
//    let HasErrors:Bool?
//    let Notifications:[LogisticsCalculateErrorModel]?
//    
//    let TotalAmount:LogisticsCalculateRateTotalAmountModel?
//    let RateDetails:LogisticsCalculateRateDetailsModel?
//  
//    var error:String?
    
    
    var TotalAmountBeforeTax:String?
    var serviceType:String?
    
    var TotalAmount:Double?
    var TaxAmount:Double?
   
//    "success": false,
//       "error": "Unexpected token < in JSON at position 115"
//    Notifications
}

struct LogisticsCalculateRateIndiaResponseModel: Codable {

   let charges:CustomDouble?
   var city:String?
 
}
struct LogisticsCalculateRateTotalAmountModel: Codable {
    
    let CurrencyCode:String?
    let Value:Double?
}
struct LogisticsCalculateRateDetailsModel: Codable {
    
    let Amount:CustomDouble?
    let OtherAmount1:CustomDouble?
    let OtherAmount2:CustomDouble?
    let OtherAmount3:CustomDouble?
    let OtherAmount4:CustomDouble?
    let OtherAmount5:CustomDouble?
    let TotalAmountBeforeTax:CustomDouble?
    let TaxAmount:CustomDouble?
       
}

struct LogisticsCalculateErrorModel: Codable {
    let Code:String?
    let Message:String?
}
