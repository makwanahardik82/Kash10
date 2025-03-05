//
//  TransactionModel.swift
//  Peko
//
//  Created by Hardik Makwana on 31/03/23.
//

import UIKit
struct TransactionResponseModel: Codable {
    let totalData:Int?
    let result:[TransactionModel]?
}

struct TransactionModel: Codable {
    
    let id:Int?
    var corporateTxnId:String?
    var transactionDate:String?
  
    //var credentialId:Int?
   
    var transactionCategory:String?
    var corporateCashback:String?
   
    var serviceOperator:ServiceOperatorModel?
    
    var order:TransactionOrderModel?
   
    var date:Date {
        get {
            return self.transactionDate!.dateFromISO8601() ?? Date()
        }
    }
    var bill_amount:Double {
        get {
            if objShareManager.appTarget == .PekoUAE {
                return self.order?.amountInUsd?.value ?? 0.0
            }else{
                return self.order?.amountInINR?.toDouble() ?? 0.0
            }
        }
    }
}
struct TransactionOrderModel: Codable {
    let id:Int?
    let amountInUsd:CustomDouble?
    let amountInINR:String?
    let paymentMode:String?
    let status:String?
}
struct OperatorModel: Codable {
    let serviceProvider:String?
}
