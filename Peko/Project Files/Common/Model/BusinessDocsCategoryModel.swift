//
//  BusinessDocsCategoryModel.swift
//  Peko
//
//  Created by Hardik Makwana on 10/10/23.
//

import UIKit

struct BusinessDocsCategoryResponseDataModel:Codable {
    let categoryDataWithCounts:[BusinessDocsCategoryModel]?
}
struct BusinessDocsCategoryModel:Codable {
    
    let id:Int?
    
    let categoryName:String?
    let categoryImage:String?
    let documentCount:CustomInt?
    let categoryStatus:Bool?
    
    let updatedAt:String?
    let createdAt:String?

}

/*
{
    "id": 15,
    "": "Finance & Accounting",
    "": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1689077344898.png?alt=media&token=26ab23cf-7057-4326-8bb5-b34edf50e381",
    "": true,
    
    "createdAt": "2023-06-17T12:06:19.000Z",
    "updatedAt": "2023-07-11T12:09:05.000Z",
    "vendorId": 12,
  
    "vendor": {
        "id": 12,
        "vendorName": "edocs",
        "type": "documnet",
        "isActive": true,
        "apiUrl": "https://peko.one",
        "healthUrl": "https://peko.one",
        "optional1": "",
        "optional2": "",
        "optional3": "",
        "optional4": "",
        "optional5": "",
        "optional6": "",
        "isBillPaymentAvailable": null,
        "isTopUpAvailable": null,
        "currency": null,
        "createdAt": "2023-06-15T07:00:32.000Z",
        "updatedAt": "2023-06-15T07:00:32.000Z"
    }
},
*/


struct BusinessDocsDocumentResponseDataModel:Codable {
    let documents:[BusinessDocsDocumentModel]?
    let totalCount:CustomInt?
}
struct BusinessDocsDocumentModel:Codable {
    
    let id:Int?
    
    let documentName:String?
    let description:String?
    
    let documentUrl:String?
  
    let status:Bool?
    
    let updatedAt:String?
    let createdAt:String?

}

/*
{
            "id": 1,
            "": "Cash Receipt",
            "": "Secure a cash receipt for your customers and accounting department using this sample.",
            "": "https://firebasestorage.googleapis.com/v0/b/peko-a2d2f.appspot.com/o/docs%2F1677150519941.pdf?alt=media&token=895a3564-c37f-4a8d-bc40-a2ff8a9c51d8",
            "": true,
            "createdAt": "2023-02-23T11:08:42.000Z",
            "updatedAt": "2023-02-23T11:08:42.000Z",
            "categoryId": 22,
            "category": {
                "id": 22,
                "categoryname": "HR"
            }
        }
*/
