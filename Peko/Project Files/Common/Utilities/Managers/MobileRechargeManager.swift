//
//  MobileRechargeManager.swift
//  Kash10
//
//  Created by Hardik Makwana on 22/06/24.
//

import UIKit

var objMobileRechargeManager:MobileRechargeManager? // =

class MobileRechargeManager: NSObject {
    
    static let sharedInstance = MobileRechargeManager()
   
    var selectedOperatorModel:MobileRechargeOperatorModel?
    var selectedPlanModel:MobileRechargePlanModel?
    var mobileNumber = ""
    
   // var isInternational = false
    var currencySymbol = "$ "
    var phoneCode = "+1"
    
    var paymentResponseModel:MobileRechargePaymentOrderReceiptModel?
}
