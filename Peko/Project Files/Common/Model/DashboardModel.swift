//
//  DashboardModel.swift
//  Peko
//
//  Created by Hardik Makwana on 30/03/23.
//

import UIKit

struct DashboardModel: Codable {
    
    let totalCashback:CustomDouble?
   // let totalRevenue:Double?
    let totalSpendCurrentMonth:CustomDouble?
    let balance:CustomDouble?
    //var walletData:WalletDataModel?
    var totalSpend:CustomDouble?
    var allBanners:[BannersDataModel]?
    var alerts:[AlertDataModel]?
    
    
}

struct WalletDataModel: Codable {
    let id:Int?
    let balance:String?
    var createdAt:String?
    var updatedAt:String?
   
   // let credentialId:String?
   
//    let credential:String?
//    let createdAt:String?
//    let updatedAt:String?
}
struct BannersDataModel: Codable {
    let id:Int?
    let bannerTitle:String?
    var bannerLink:String?
    var description:String?
    let highlights:String?
    let bannerImage:String?
}
struct AlertDataModel: Codable {
    let type:String?
    var message:String?
    var action:String?
    let linkUrl:String?
    let providerImage:String?
}
/*
        "id": 27,
        "balance": "68506.5030",
        "createdAt": "2022-11-07T18:45:31.000Z",
        "": "2023-03-28T16:45:01.000Z",
        "": 27,
        "credential": {
            "id": 27,
            "role": "CORPORATE",
            "username": "100000006",
            "name": "Eresolute",
            "password": "$2a$10$VWJhZow5KZ7RAwmS.4Tn5eImHrkUElzeJC43TOfpYnnZzCjA5pKpS",
            "passwordResetToken": null,
            "passwordResetExpires": null,
            "registeredBy": null,
            "createdAt": "2022-11-07T18:45:31.000Z",
            "updatedAt": "2022-11-07T18:46:57.000Z"
        }
    }
    */
