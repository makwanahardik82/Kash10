//
//  LogisticsCreateShipmentResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 25/10/23.
//

import UIKit

struct LogisticsCreateShipmentResponseModel: Codable {
    
   // let HasErrors:Bool?
   // let Notifications:[LogisticsCalculateErrorModel]?
    
    let ProcessedPickup:LogisticsProcessedPickupModel?
    let corporateTxnId:CustomInt?
    let AWBNumber:String?
}


struct LogisticsProcessedPickupModel: Codable {
    
    let ID:String?
    let GUID:String?
    let Reference1:String?
   // let Reference2:String?
    let ProcessedShipments:[LogisticsProcessedShipmentsModel]?
    
    
}

struct LogisticsProcessedShipmentsModel: Codable {
    
    let ID:String?
    
    let Reference1:String?
   // let Reference2:String?
    // let Reference3:String?
    
    let ForeignHAWB:String?
   
    let HasErrors:Bool?
   
 //   let Notifications:[LogisticsCalculateErrorModel]?
   
//    let ShipmentLabel:String?
//    let ShipmentDetails:String?
//    let ShipmentAttachments:[]?
}
struct LogisticsShipmentTrackModel: Codable {
    
    let shipmentStatus:[PekoStoreShipmentStatusModel]?
    let amount:String?
    let orderResponse:String?
    
}

struct LogisticsPincodeResponseDataModel: Codable {
    
    let type:String?
    let percentage:Int?
    let city:String?
    let data:[LogisticsPincodeDataModel]?
    
}
struct LogisticsPincodeDataModel: Codable {
    let weight_from:Int?
    let weight_to:Int?
    let cost_price:String?
    let cod:Bool?
    let cod_charges:String?
}

struct MerchantAddressResponseDataModel: Codable {
   
    let data:MerchantAddressModel?
    
}

struct MerchantAddressModel: Codable {
    let nickname:Int?
    
    let name:String?
    let city:String?
    let country:String?
    let state:String?
    let addressLine1:String?
    let email:String?
    let phoneNumber:String?
    let zipCode:String?
    let remarks:String?
    let credentialId:CustomInt?
}




/*
"Transaction": {
           "Reference1": "",
           "Reference2": "",
           "Reference3": "",
           "Reference4": "",
           "Reference5": ""
       },
       "Notifications": [],
       "HasErrors": false,
       "TrackingResults": [
           {
               "Key": "44261925190",
               "Value": [
                   {
                       "WaybillNumber": "44261925190",
                       "UpdateCode": "SH014",
                       "UpdateDescription": "Record created.",
                       "UpdateDateTime": "/Date(1706788140000+0300)/",
                       "UpdateLocation": "Dubai, United Arab Emirates",
                       "Comments": "",
                       "ProblemCode": "",
                       "GrossWeight": "10",
                       "ChargeableWeight": "10",
                       "WeightUnit": "KG"
                   }
               ]
           }
       ],
       */
