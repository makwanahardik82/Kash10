//
//  MobilePrepaidResponseModel.swift
//  Peko India
//
//  Created by Hardik Makwana on 19/12/23.
//

import UIKit

struct MobilePrepaidPlanResponseModel:Codable {
    
    let responseCode:String?
    let responseMessage:String?
    let success: Bool?
    let message:String?
    let plans:[MobilePrepaidPlanModel]?
    let planCategory:[String]?
}

struct MobilePrepaidPlanModel:Codable {
   
    let success: Bool?
   
    let Description:String?
    let LocationName:String?
    let PlanName:String?
    
    let ServiceProviderName:String?
    let Validity:String?
    
    let Amount:CustomDouble?
    let ServiceId:Int?
    
    let ServiceProviderId:Int?
    let Talktime:CustomDouble?
    
}

struct MobilePrepaidBillPaymentModel: Codable{
 
    let Amount:CustomString?
    let amount:CustomString?
    let SystemReference:CustomString?
   
    
    let RechargeNumber:String?
    let ServiceType:String?
    let IsPostPaid:String?
    let TransactionReference:String?
   
    let FailureReason:String?
    let RechargeRequestDateTime:String?
    let OperatorTransactionId:String?
    let CommissionAmount:String?
   
    let corporateFinalBalance:String?
    let corporateCashback:String?
    let paymentMode:String?
    let datetime:String?
   
}
