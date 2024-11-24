//
//  NIPaymentResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 18/05/24.
//

import UIKit

struct NIPaymentResponseModel:Codable {
   
    let corporateFinalBalance:String?
    let corporateCashback:String?
  
    let orderId: CustomInt?
    let transactionId: CustomInt?
    let corporateTxnId:CustomInt?
 
    let datetime: String?
   
    let amount: CustomDouble?
//
//    let paidAmount: CustomString?
//    
//    let couponDetails:[CouponDetails]?
//    
   
    
//    let amount: String?

    var date:Date {
        get {
            return self.datetime!.dateFromISO8601() ?? Date()
        }
    }
}
