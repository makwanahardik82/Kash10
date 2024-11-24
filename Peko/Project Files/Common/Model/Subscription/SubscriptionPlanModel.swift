//
//  SubscriptionPlanModel.swift
//  Peko
//
//  Created by Hardik Makwana on 23/07/23.
//

import UIKit

struct SubscriptionPlanResponseModel: Codable {
  //  let success:Bool?
    let planDatas:[SubscriptionPlanModel]?
}
struct SubscriptionPlanModel: Codable {

    let id:Int?
    
    let name:String?
    let price:String?
    let validity:String?
    let description:String?
    let subscriptionType:String?
    let includes:String?
   
    let status:Bool?
   
    let updatedAt:String?
    let createdAt:String?

    let productId:Int?
    let product:SubscriptionProductModel?

    let features:String?
   
  
    
}

/*
"id": 3,
         "name": "Premium Plan",
         "price": "1000.0000",
         "": "1",
         "description": "Premium Plan for Office 365",
         "status": true,
         
"createdAt": "2023-07-07T09:59:02.000Z",
         "updatedAt": "2023-07-07T09:59:02.000Z",
         "productId": 35,
       
"product": {
             "id": 35,
             "name": "Office 365",
             "description": "Desktop versions of Office apps with premium features, Easily host webinars, Attendee registration and reporting tools",
             "SKUCode": "000",
             "productImage": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1687708494120.png?alt=media&token=d9cd790a-4f07-4d56-a589-2d8666f8d0fa",
             "price": "9000.00",
             "quantity": 1000,
             "status": true,
             "createdAt": "2023-06-25T15:54:55.000Z",
             "updatedAt": "2023-07-05T20:45:56.000Z",
             "categoryId": 18
         }
*/
