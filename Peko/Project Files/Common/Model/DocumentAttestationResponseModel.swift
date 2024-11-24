//
//  DocumentAttestationResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 04/05/24.
//

import UIKit

//class DocumentAttestationResponseModel: NSObject {
//
//}
struct DocumentAttestationCountriesDataModel: Codable {
    let data:[DocumentAttestationCountriesModel]?
}
struct DocumentAttestationCountriesModel: Codable {
    
    let value:String?
    let label:String?
    
}

struct DocumentAttestationCategoryDataModel: Codable {
    let data:[DocumentAttestationCategoryModel]?
}
struct DocumentAttestationCategoryModel: Codable {
    
    let value:String?
    let label:String?
    let price:CustomDouble?
    
}
struct DocumentAttestationPriceModel: Codable {
    
    let price:CustomDouble?
    let actualPrice:CustomDouble?
  
}

struct DocumentAttestationFileURLModel: Codable {
    
    let firebaseUrl:String?
  
}
struct DocumentAttestationPaymentModel: Codable {
    
    let corporateFinalBalance:CustomString?
    let corporateCashback:CustomString?
    
    let orderId:CustomString?
    let transactionId:CustomString?
    let datetime:String?
    
    let amount:CustomDouble?
    let corporateTxnId:CustomInt?
    
    
    var date:Date {
        get {
            return self.datetime!.dateFromISO8601() ?? Date()
        }
    }
}

