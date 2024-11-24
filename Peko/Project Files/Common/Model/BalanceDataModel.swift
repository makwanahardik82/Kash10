//
//  BalanceDataModel.swift
//  Peko
//
//  Created by Hardik Makwana on 28/01/23.
//

import UIKit

struct BalanceDataModel: Codable {

    // COMMON
    let ResponseCode:String?
    let ResponseMessage:String?
    
    let TransactionId:String?
    let surchargeInAED:String?
    let dueBalanceInAed:String?
    
  // DU PREPAID
    let PersonNameEnglish:String?
    let PersonNameArabic:String?
    
    let MobileNumber:String?
  
    let Accounts:[AccountsData]?
    
    
    // DU POSTPAID
    let custName:String?
   
 //   let Balance:String?
    let OrderId:String?
    let ProviderTransactionId:String?
    let PoboxNo:String?
    let PremiseType:String?
    let Area:String?
    
    // Etisalat Prepaid
    let CurrentBalance:String?
    /*
    {
        "success": true,
        "data": {
            "ResponseCode": "000",
            "ResponseMessage": "SUCCESS",
            "surchargeInAED": "0.00",
            "minimumAmountInAed": 5,
            "maximumAmountInAed": 1000,
            "TransactionId": "230129115937623050"
        }
    }
    */
    // Lootah - Utility
    let GasAccountNo:String?
    let WalletDetails:[WalletDetailsModel]?
    let ProductDetails:[HafilatProductDetailsModel]?
    
}
// HAFILAT
struct HafilatProductDetailsModel: Codable {
    
    let ProductCode:String?
    let ProductTitle:String?
    let TransactionType:String?
   
    let ProductCategory:String?
    let ValidityStartDate:String?
    let ValidityEndDate:String?
   
    let BalanceAmount:CustomDouble?
    let AmountInProcess:CustomDouble?
    let MaximumAllowed:CustomDouble?
    
 
}
// DARB
struct WalletDetailsModel: Codable {
    
    let customerEN:String?
    let customerAR:String?
    let walletIdentity:String?
    
}

struct AccountsData: Codable {
    
    let AccountNumber:String?
    
    let PremiseType:String?
    let Area:String?
    let AccountType:String?
    let PoBox:String?
    let Balance:CustomString?
    
    
    enum CodingKeys: String, CodingKey {
        case AccountNumber
        
        case PremiseType
        case Area
      
        case AccountType
        case PoBox
        case Balance
    }
}

/*
 
 
 {
     "success": true,
     "data": {
         "ResponseCode": "000",
         "ResponseMessage": "SUCCESS",
         "PersonNameEnglish": "سعيد محمد سعيد مسيعد النيادي",
         "PersonNameArabic": "",
         "MobileNumber": "",
         "Accounts": [
             {
                 "AccountNumber": "6143800000",
                 "PremiseType": "Shaabia",
                 "Area": "مزيد",
                 "AccountType": "سعيد محمد سعيد مسيعد النيادي  - Residential",
                 "PoBox": "0",
                 "Balance": "604.71"
             }
         ],
         "TransactionId": "230121101646303050",
         "surchargeInAED": "0.00",
         "dueBalanceInAed": "604.7100"
     }
 }
 
 */
