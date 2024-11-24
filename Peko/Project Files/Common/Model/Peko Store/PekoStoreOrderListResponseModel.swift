//
//  PekoStoreOrderListResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 13/03/24.
//

import UIKit


struct PekoStoreOrderListResponseModel: Codable {
    let result:[PekoStoreOrderListModel]?
    let totalData:Int?
}
struct PekoStoreOrderListModel: Codable {
    let order:PekoStoreOrderModel?
}
struct PekoStoreOrderModel: Codable {
    
    let id:Int?
    
    let amountInAed:String?
    let paymentMode:String?
    
    let status:String?
    let orderResponse:String?
    
    let ecomOrderStatus:String?
    let transactionDate:String?
    
    let corporateTxnId:String?
    let providerId:String?
    
    var productName:String {
        let dic = self.orderResponse?.convertToDictionary()
        
        if let productArray = dic!["products"] as? [[String:Any]], let p_dic = productArray.first{
            if let name = p_dic["productName"] as? String {
                return name
            }
        }
        return ""
    }
}


struct PekoStoreOrderDetailModel: Codable {
    
    let id:Int?
    
    let amountInAed:String?
    let paymentMode:String?
    
    let status:String?
    
    let ecomOrderStatus:String?
    let transactionDate:String?
    
    let corporateTxnId:String?
    
    let operatorId:String?
    let providerId:String?
    let accountNo:String?
    let baseAmount:String?
    
    let paymentModeResponse:String?
    let surcharge:String?
    let baseCurrency:String?
    let exchangeRate:CustomInt?
    let message:String?
   
  //  let ecomOrderStatus:String?
    let workspaceOrderStatus:String?
   
    let createdAt:String?
    let updatedAt:String?
    let serviceOperatorId:CustomInt?
    let credentialId:CustomInt?
    
    let shipmentStatus:[PekoStoreShipmentStatusModel]?
   
    let orderResponse:PekoStoreOrderResponseModel?
    
}

struct PekoStoreShipmentStatusModel: Codable {
    let Comments:String?
    let UpdateCode:String?
    let UpdateDateTime:String?
}

struct PekoStoreOrderResponseModel: Codable {
    let products:[PekoStoreOrderProductModel]?
    let address:PekoStoreAddressModel?
    let trackingDetails:PekoStoreTrackingDetailsModel?
}


struct PekoStoreOrderProductModel: Codable {
    let productId:Int?
    let productQuantity:Int?
    let productName:String?
    let totalPrice:CustomDouble?
    let totalVat:CustomDouble?
    let image:String?
}

struct PekoStoreAddressModel: Codable {
   
    let address:String?
    let phoneNumber:String?
    let remarks:String?
    let saveThisAddress:Bool?
    
}

struct PekoStoreTrackingDetailsModel: Codable {
   
    let deliveryPartner:String?
    let trackingNumber:CustomInt?
    let trackingWebsite:String?
    
}
