//
//  PaymentManager.swift
//  Peko India
//
//  Created by Hardik Makwana on 20/12/23.
//

import UIKit

enum ReviewPaymentType: Int {
    case MobilePrepaidRecharge = 0
    case MobilePostpaidRecharge
  //  case UtilityElectricity
    case UtilityBills
//    case AirTicket
//    case SubscriptionPayment
//    case Logistics
//    case License
//    case OfficeAddress
//    case GiftCard
    
}

var objPaymentManager:PaymentManager?

class PaymentManager: NSObject {

    static let sharedInstance = PaymentManager()
  
    var screenTitle:String = ""
    var reviewPaymentType:ReviewPaymentType?
    var billSummaryArray = [Dictionary<String, String>]()
  
    //var amount:Double = 0.0
   
    
    var transactionID:String = ""
    var dateString:String = ""
    var timeString:String = ""
    
    var service:String = ""
    var consumerNumber:String = ""
    var serviceProvider:String = ""
    
    var price:Double = 0.0
    var voucher:Double = 0.0
    var totalAmount:Double = 0.0
  
    
}
