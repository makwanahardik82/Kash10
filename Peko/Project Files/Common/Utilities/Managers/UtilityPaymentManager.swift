//
//  UtilityPaymentManager.swift
//  Peko
//
//  Created by Hardik Makwana on 01/04/23.
//

import UIKit

var objUtilityPaymentManager:UtilityPaymentManager?

class UtilityPaymentManager: NSObject {

    static let sharedInstance = UtilityPaymentManager()
   
    var limitDataModel:LimitDataModel?
    var balanceDataModel:BalanceDataModel?
    var utilityPaymentType:UtilityPaymentType?
  
    var utilityPaymentRequest:UtilityPaymentRequest?
    
    var dapiPaymentResponse:[String:Any]?
    
    var paymentTransactionModel:PhoneBillPaymentDataModel?
}
