//
//  MobilePostpaidBillModel.swift
//  Peko India
//
//  Created by Hardik Makwana on 19/12/23.
//

import UIKit
struct MobilePostpaidBillResponseModel:Codable {
    let data:MobilePostpaidBillDataModel?
    let success:Bool?
    let traceId:String?
}

struct MobilePostpaidBillDataModel: Codable {

    let status:String?
    let refId:String?
    let billerRefId:String?
    
    let bill:MobilePostpaidBillModel?
    
}

struct MobilePostpaidBillModel: Codable {
    
    let amount:CustomString?
    let billDate:String?
    
    let billNumber:CustomString?
    let billPeriod:String?
    
    let customerName:String?
    let dueDate:String?
}


struct MobilePostpaidBillPaymentModel: Codable{
 
    let traceId:String?
    let message:String?
    
    let corporateFinalBalance:String?
    let corporateCashback:String?
    
    let datetime:String?
    let amount:CustomString?
    
    let corporateTxnId:CustomString?
    let success:Bool?
    
    let data:MobilePostpaidBillPaymentDataModel?
}
struct MobilePostpaidBillPaymentDataModel:Codable{
  
    let message:String?
    let billerId:String?
    let billerRefId:String?
    let refId:String?
    let status:String?
    let transactionId:String?
  
    
}

/*
"data": {
           "billerId": "OTOE00005XXZ43",
           "billerRefId": "12345037",
           "paymentDetails": {
               "amount": 100000,
               "mode": "Debit Card",
               "paymentRefId": "1703053548033",
               "timestamp": "2023-12-20T06:25:48.033Z"
           },
           "refId": "CM18HRG6SR3VSSFM2LD00Q2CTIN33541155",
           "status": "Success",
           "transactionId": "AS0133541155508XDIS5"
       },
       "success": true,
       "traceId": "CM18HSO6SR3VSSFM2LF0",
       "message": "Payment Successful",
       "corporateFinalBalance": "73270624.8943",
       "corporateCashback": "50",
       "datetime": "2023-12-20T06:25:55.660Z",
       "amount": 100000,
       "corporateTxnId": 1703053548033
   }
*/
