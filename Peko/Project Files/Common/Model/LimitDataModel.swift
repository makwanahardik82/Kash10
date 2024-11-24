//
//  LimitDataModel.swift
//  Peko
//
//  Created by Hardik Makwana on 27/01/23.
//

import UIKit

struct LimitDataModel: Codable {
 
    let id: Int?
    
    let minDenomination: Int?
    let maxDenomination: Int?
    
    let baseCurrency:String?
    let planCurrency:String?
    let flexiKey:String?
    
    let typeKey: Int?
    
    let serviceProvider:String?
    let accessKey:String?
    let serviceStatus: Int?
    let providerCommission:String?
    
    let serviceImage:String?
    let serviceCategory:String?
    let remarks:String?
    let countryName:String?
    let countryCode: Int?
    
    let balanceMethod: Int?
    let commissionType:String?
    let serviceType:String?
    let isPlanAvailable: Int?
    
    let createdAt:String?
    let updatedAt:String? // 2023-01-15T10:34:11.000Z
  
    let vendorId:Int?
    let vendor:Vendor?
    
    let cashbackType:String?
    let cashback:String?
    let packageId: Int?
    let serviceOperatorId: Int?
    let surcharge:String?
    
    enum CodingKeys: String, CodingKey {
        case id
        
        case minDenomination
        case maxDenomination
        
        case baseCurrency
        case planCurrency
        case flexiKey
        
        case typeKey
        
        case serviceProvider
        case accessKey
        case serviceStatus
        case providerCommission
        
        case serviceImage
        case serviceCategory
        case remarks
        case countryName
        case countryCode
        
        case balanceMethod
        case commissionType
        case serviceType
        case isPlanAvailable
        
        case createdAt
        case updatedAt
        
        case vendorId
        case vendor
        
        case cashbackType
        case cashback
        case packageId
        case serviceOperatorId
        case surcharge
        
       //  case phoneBillType
    }
 
}

struct Vendor: Codable {
    
    let apiUrl:String?
    
    let optional1:String?
    let optional2:String?
    let optional3:String?
    let optional4:String?
    
    
    enum CodingKeys: String, CodingKey {
        case apiUrl
        
        case optional1
        case optional2
        
        case optional3
        case optional4
    }
}

