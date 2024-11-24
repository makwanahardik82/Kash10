//
//  SubscriptionProductModel.swift
//  Peko
//
//  Created by Hardik Makwana on 23/07/23.
//

import UIKit
import CodableFirebase

struct SubscriptionProductResponseDataModel: Codable {
   
    let recordsTotal:Int?
    let recordsFiltered:Int?
    let data:[SubscriptionProductModel]?
            
}
struct SubscriptionProductDetailResponseModel: Codable {
//    let success:Bool?
    let data:SubscriptionProductModel?
}

struct SubscriptionProductModel:Codable {
    
    let id:Int?
    let name:String?
    let productImage:String?
    let price:CustomString?
  
    let discountType:String?
    let discount:CustomString?
    let actualPrice:CustomString?
    
    
    // INDIA
    let image:String?
    
    let description:String?
    let highlights:String?
    let SKUCode:CustomString?
    let quantity:Int?
    
//    let status:Bool?
    
    let updatedAt:String?
    let createdAt:String?
    
    let categoryId:Int?
    
   
    
    
 /*
    "id": 405,
                  "productImage": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1710235329547.png?alt=media&token=568c0003-0002-4252-b640-88e7cd601cd1",
                  "price": "25.00",
                  "name": "McAfee"
    
    
    
    
    "id": 24,
                   "": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1713434580881.png?alt=media&token=12ec6a33-35b1-4133-ad44-d33259f0cf00",
                   "name": "Microsoft",
                   "discount": "20% Off",
                   "description": "Microsoft 365 is a comprehensive subscription-based service offered by Microsoft that combines the familiar Office applications with cloud-based services, device management, and advanced security features. It is designed to empower individuals and organizations to achieve more with flexible and integrated tools.",
                   "category": {
                       "categoryName": "Office Suite",
                       "id": 47
                   }
    */
}


struct SubscriptionHistoryResponseModel: Codable {
  //  let success:Bool?
    let result:[SubscriptionHistoryOrderResponseModel]?
    let totalData:Int?
}
struct SubscriptionHistoryOrderResponseModel: Codable {
    let order:SubscriptionHistoryOrderModel?
}
struct SubscriptionHistoryOrderModel: Codable {
    let id:Int?
    // let amountInAed:String?
    let paymentMode:String?
    let status:String?
    let orderResponse:String?
    
    let ecomOrderStatus:String?
    let transactionDate:String?
  
    let amountInINR:CustomString?
    
    var orderResponseDictionary:[String:Any] {
        get {
            if let array = self.orderResponse?.toJSON() as? [String:Any] {
                return array
            }
            return [String:Any]()
        }
    }
    
    var subscriptionType:String? {
        if let subscriptionDetails = orderResponseDictionary["subscriptionDetails"] as? [String:Any], let product = subscriptionDetails["subscriptionType"]  as? String {
            return product
        }
        return ""
    }
    
    var product:SubscriptionProductModel? {
        if let subscriptionDetails = orderResponseDictionary["subscriptionDetails"] as? [String:Any], let product = subscriptionDetails["product"]  as? [String:Any] {
            
            do {
                let model = try FirebaseDecoder().decode(SubscriptionProductModel.self, from: product)
                return model
            } catch let error {
                print(error)
            }
        }
        return nil
        
    }
    var software:SubscriptionProductModel? {
        if let subscriptionDetails = orderResponseDictionary["subscriptionDetails"] as? [String:Any], let product = subscriptionDetails["software"]  as? [String:Any] {
            
            do {
                let model = try FirebaseDecoder().decode(SubscriptionProductModel.self, from: product)
                return model
            } catch let error {
                print(error)
            }
        }
        return nil
        
    }
    
    var baseProduct:SubscriptionProductModel? {
        if let subscriptionDetails = orderResponseDictionary["subscriptionDetails"] as? [String:Any] {
            
            do {
                let model = try FirebaseDecoder().decode(SubscriptionProductModel.self, from: subscriptionDetails)
                return model
            } catch let error {
                print(error)
            }
        }
        return nil
    }
}

struct SubscriptionPaymentResponseModel:Codable {
    
    
    let corporateFinalBalance:String?
    let corporateCashback:String?
    let orderId: CustomInt?

    let datetime: String?
    let amount: CustomDouble?
    let corporateTxnId:CustomInt?

    var date:Date {
        get {
            return self.datetime!.dateFromISO8601() ?? Date()
        }
    }
}
