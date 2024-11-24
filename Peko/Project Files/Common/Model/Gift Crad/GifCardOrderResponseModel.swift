//
//  GifCardOrderResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 14/05/23.
//

import UIKit

struct GiftCardOrderResponseModel: Codable {
    var success:Bool = false
    var data: GiftCardOrderModel?
    var error:String?
    
//    var orderId:String?
//    var refno:String?
//
//
//    var message:String?
//    var code:Int?
    
//    
//    "code": 400,
//            "message": "The request data is invalid.",
//            "messages": [
//                "address: This is not a valid telephone number"
//            ],
//            "additionalTxnFields": [],
//            "corporateFinalBalance": "16495.6619"
    
}
struct GiftCardOrderModel:Codable {
    let trans_id:CustomString?
    
    
//    let order_id:Int?
//    let reference_id:String?
//    
//    let code:Int?
//    let message:String?
//    let messages:[CustomString]?
//    let corporateFinalBalance:String?
//    let corporateTxnId:String?
    
}
