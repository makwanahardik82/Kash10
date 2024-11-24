//
//  MobileRechargeModel.swift
//  Kash10
//
//  Created by Hardik Makwana on 22/06/24.
//

import UIKit


struct MobileRechargeOperatorsListResponseModel: Codable {
    let success:Bool?
    let message:String?
    let products:[MobileRechargeOperatorModel]?
}
struct MobileRechargeOperatorModel: Codable {
    
    let productId:Int?
    let operatorId:Int?
 
    let productName:String?
    let countryCode:String?
    let operatorName:String?
    let imageUrl:String?
    let icon:String?
    
}

struct MobileRechargePlansListResponseModel: Codable {
    let success:Bool?
    let message:String?
    let products:[MobileRechargePlanModel]?
}
struct MobileRechargePlanModel: Codable {
    
    let skuId:Int?
    let productId:Int?
    let salesTax:Int?
    let localPhoneNumberLength:Int?
    let fee:Int?
    let operatorId:Int?
 
    
    let isSalesTaxCharged:Bool?
    let allowDecimal:Bool?
    
    let productName:String?
    let category:String?
    let countryCode:String?
    let benefitType:String?
    let validity:String?
    let productDescription:String?
    let operatorName:String?
    let imageUrl:String?
    let additionalInformation:String?
    let region:String?
    
    let min:MobileRechargePlanMinMaxModel?
    let max:MobileRechargePlanMinMaxModel?
    
}

struct MobileRechargePlanMinMaxModel: Codable {
    
    let faceValue:CustomDouble?
    let deliveredAmount:CustomDouble?
    let cost:CustomDouble?
 
    let faceValueCurrency:String?
    let deliveryCurrencyCode:String?
    let costCurrency:String?
    
}



// MARK: - Payment
struct MobileRechargePaymentResponseModel: Codable {
    let success:Bool?
    let message:String?
    let OrderReceipt:MobileRechargePaymentOrderReceiptModel?
}

struct MobileRechargePaymentOrderReceiptModel: Codable {
    
    let transactionId:Int?
    
    let invoiceAmount:CustomDouble?
    let faceValue:CustomDouble?
    let discount:CustomDouble?
    let fee:CustomDouble?
    
    let transactionDate:String?
    let pins:String?
    let giftCardDetail:String?
    let simInfo:String?
    let billPaymentDetail:String?
    let esimDetail:String?
   
    let product:MobileRechargePaymentOrderReceiptProductModel?
    let topupDetail:MobileRechargePaymentOrderReceiptTopupDetailModel?
    
    var date:Date {
        get {
            return self.transactionDate?.toDate(format: "mm/dd/yyyy hh:mm") ?? Date()
        }
    }
}
struct MobileRechargePaymentOrderReceiptProductModel: Codable {
    let skuId:Int?
    let faceValue:CustomDouble?
    let productName:String?
    let instructions:String?
}

struct MobileRechargePaymentOrderReceiptTopupDetailModel: Codable {
    let localCurrencyAmount:CustomDouble?
    let salesTaxAmount:CustomDouble?
    let localCurrencyAmountExcludingTax:CustomDouble?
  
    let destinationCurrency:String?
    let operatorTransactionId:String?
}
