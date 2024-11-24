//
//  AncillariesViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 26/03/24.
//

import UIKit

struct AncillariesResponseModel: Codable {
 
    let conversationId:String?
 
    let meta:AncillariesMetaModel?
    let commonData:AncillariesCommonDataModel?
   
    let data:[AncillariesDataModel]?
    
}
struct AncillariesMetaModel: Codable {
 
    let success:Bool?
 
    let statusCode:CustomInt?
    let statusMessage:String?
   
    let actionType:String?
    let conversationId:String?
    
}
struct AncillariesCommonDataModel: Codable {
    let searchKey:CustomInt?
    let productCode:String?
}

struct AncillariesDataModel: Codable {
   
    let ancillaryOfferId:String?
    let success:Bool?
    let priceChanged:Bool?
    
    let fare:AncillariesDataFareModel?
    
}
struct AncillariesDataFareModel: Codable {
    let buyingCurrency:String?
    let buyingAmount:CustomDouble?
    
    let sellingCurrency:String?
    let sellingAmount:CustomDouble?
}
