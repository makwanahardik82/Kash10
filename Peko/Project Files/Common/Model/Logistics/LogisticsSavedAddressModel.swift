//
//  LogisticsSavedAddressModel.swift
//  Peko
//
//  Created by Hardik Makwana on 14/09/23.
//

import UIKit


struct LogisticsSavedAddressModel: Codable {

    let id:Int?
    let name:String?
    let nickname:String?
    let department:String?
    let city:String?
    let country:String?
    let countryCode:String?
    let addressLine1:String?
    
    let addressLine2:String?
    let phoneNumber:String?
    let email:String?
    
    let zipCode:String?
   // let isReceiver:Int?
   
    let createdAt:String?
    let updatedAt:String?
    
    let credentialId:CustomInt?
}


//"id": 3,
//            "": "abdulla",
//            "": "abdu",
//            "": null,
//            "": null,
//            "": null,
//            "": "EMK House",
//            "": "Near post office",
//            "": "7736600289",
//            "": null,
//            "": null,
//            "": null,
//            "": 0,
//            "": "2023-08-26T05:48:02.000Z",
//            "": "2023-08-26T05:48:02.000Z",
//            "credentialId": 22
