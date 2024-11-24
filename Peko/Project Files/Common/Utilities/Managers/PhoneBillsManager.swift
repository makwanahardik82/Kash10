//
//  PhoneBillsManager.swift
//  Peko
//
//  Created by Hardik Makwana on 28/01/23.
//

import UIKit
import DapiSDK

var objPhoneBillsManager:PhoneBillsManager? // = PhoneBillsManager.sharedInstance

class PhoneBillsManager: NSObject {

    static let sharedInstance = PhoneBillsManager()
   
    var limitDataModel:LimitDataModel?
    var balanceDataModel:BalanceDataModel?
    var phoneBillType:PhoneBillType?
    
    var duPrePaidServiceTypeArray = ["Time", "Data", "International", "Credit"]
    var etisalatPrePaidServiceTypeArray = ["Wasel Recharge"]
    var etisalatPostPaidServiceTypeArray = ["Postpaid", "Landline", "Internet", "AlShamil", "eVision", "eLife"]
  
    
    var serviceTypeValueDictionary = [
        "Time":"time",
        "Data":"data",
        "International":"international",
        "Credit":"credit",
        "Wasel Recharge":"WaselRecharge",
        "Postpaid":"GSM",
        "Landline":"DEL",
        "Internet":"DAILUP",
        "AlShamil":"BROADBAND",
        "eVision":"EVSION",
        "eLife":"ELIFE",
        "":""
    ]
   
    var phoneBillRequest:PhoneBillRequest?
    
    var dapiPaymentResponse:[String:Any]?
    
    
    
    var paymentTransactionModel:PhoneBillPaymentDataModel?
}
