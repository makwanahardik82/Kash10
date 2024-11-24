//
//  SubscriptionPaymentManager.swift
//  Peko
//
//  Created by Hardik Makwana on 23/07/23.
//

import UIKit


var objSubscriptionPaymentManager:SubscriptionPaymentManager?

class SubscriptionPaymentManager: NSObject {
    
    static let sharedInstance = SubscriptionPaymentManager()
    
    var product:SubscriptionProductModel?
    var plan:SubscriptionPlanModel?
    var request:SubscriptionPaymentRequest?
    
    
    var paymentResponseModel:SubscriptionPaymentResponseModel?
}
