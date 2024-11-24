//
//  LicenseBalanceModel.swift
//  Peko
//
//  Created by Hardik Makwana on 13/09/23.
//

import UIKit

struct LicenseBalanceModel: Codable {
    
    // COMMON
    let ResponseCode:String?
    let ResponseMessage:String?
    
    let TransactionId:String?
    let surchargeInAED:String?
    
    let AccountNumber:String?
    let Amount:String?
    
    let VoucherNumber:String?
    let VocuherDate:String?
    
    let VoucherExpiryDate:String?
    let WhetherCash:String?
    
    let WhetherCheque:String?
    let WhetherCreditCard:String?
    let dueBalanceInAed:String?
    
}

