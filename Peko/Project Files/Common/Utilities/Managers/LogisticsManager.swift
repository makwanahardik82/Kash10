//
//  LogisticsManager.swift
//  Peko
//
//  Created by Hardik Makwana on 13/09/23.
//

import UIKit

var objLogisticsManager:LogisticsManager?

class LogisticsManager: NSObject {
    
    static let sharedInstance = LogisticsManager()
    
    var senderAddress:LogisticsAddressDetailModel?
    var receiverAddress:LogisticsAddressDetailModel?
    var shipmentDetailModel:LogisticsShipmentDetailModel?
  //  var countryArray:[LogisticsCountryModel]?
  //  var cityArray:[LogisticsCityModel]?
    
    // var shipmentServiceModel = LogisticsShipmentServiceModel()
    var calculateRateResponseModel:LogisticsCalculateRateResponseModel? // = (from: <#Decoder#>)
    var calculateRateResponseIndiaModel:LogisticsCalculateRateIndiaResponseModel? // = (from: 
    
    var merchantAddressModel:MerchantAddressModel?
    
    // var shipmentType:ShipmentType = .document
    
   // var shipmentSchedulePickupDate:Date? = nil
 //   var shipmentRemarkComment:String = ""
    var serviceTypeName:String?
    var isUpdateViaSMS = false
    
    func getFormatedAddress(address:LogisticsAddressDetailModel) -> String{
        let name = (address.name ?? "")
        let building = (address.buldingName ?? "")
        let city = (address.city ?? "")
        let country = (address.country ?? "")
        let email = "Email - " + (address.email ?? "")
        let phoneNumber = "Phone Number - " + (address.mobileNumber ?? "")
    
        return (name + ",\n" + building + ",\n" + city + ",\n" + country + ",\n" + email + ",\n" + phoneNumber)
    }
}


