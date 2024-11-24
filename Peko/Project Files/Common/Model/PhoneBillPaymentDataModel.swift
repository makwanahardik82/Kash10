//
//  PhoneBillPaymentDataModel.swift
//  Peko
//
//  Created by Hardik Makwana on 28/01/23.
//

import UIKit

struct PhoneBillPaymentDataModel: Codable {

    let status:String?
    let res_msg:String?
    let datetime:String?
    let ResponseCode:String?
    let paidAmountInAed:CustomDouble?
    let paidAmount:CustomDouble?
    let supplierId:String?
    let operatorId:String?
   
    let orderId:CustomString?
    let corporateFinalBalance:String?
    let corporateCashback:String?
    let couponDetails:[CouponDetails]?
    
    let errorcode:String?
    let errordesc:String?
    
    let corporateTxnId:CustomInt?
    let serviceProvider:String?
    
    let transactionDetails:TransactionDetails?
    
    let amount:CustomString? // UTILITY
    
    
    var date:Date {
        get {
            return self.datetime!.dateFromISO8601() ?? Date()
        }
    }
}
struct TransactionDetails: Codable {
    let merchantId:String?
    let status:String?
    let serviceProvider:String?
    let accountNo:String?
    
    let serviceType:String?
    let tranDate:String?
    let orderId:String?
    let amountInAed:String?
    
    let baseAmount:String?
    let dealerTxnId:String?
    let operatorId:String?
    
}
/*

"data": {
        "status": "000",
        "datetime": "2023-01-29 11:31:29",
        "ResponseCode": "000",
        "paidAmountInAed": 6,
        "paidAmount": "6",
        "supplierId": "cldgz4uhe0yi3ncoc2cmwrqu5",
        "operatorId": "N/A",
        "orderId": "cldgz4uvv000zrsmk7d1y2tlu",
        "couponDetails": [
            {
                "id": 52,
                "title": "Get 5% off on all products",
                "termsConditions": "Applicable for new & existing users. Redeemable online only",
                "validFrom": "2022-02-01",
                "validTo": "2023-12-31",
                "discount": "5",
                "discountType": "PERCENTAGE",
                "couponCode": "TPBQ7C",
                "couponImage": null,
                "partnerCode": null,
                "name": "Pottery Barn",
                "website": "https://www.potterybarn.ae",
                "subCategory": "Furniture"
            }
        ],
        "corporateFinalBalance": "19994.0000",
        "corporateCashback": "1"
    }
*/

/*
{
    "success": false,
    "data": {
        "errorcode": "DTI",
        "errordesc": "DUPLICATE TRANS ID",
        "": {
            "": "pekopayments",
            "": "REVERSAL",
            "": "DU TOPUP",
            "": "9876543210",
            "": "TOP UP",
            "": "2023-01-28T10:22:18.000Z",
            "": "cldft0e0g000nrsmkolpwfmgh",
            "": "6.0000",
            "": "6.0000",
            "": "230128142058633050",
 
            "": ""
        },
        "corporateFinalBalance": "20000.0000"
    }
}
*/
struct CouponDetails: Codable {

    let id:Int?
    
    let title:String?
    let termsConditions:String?
    let validFrom:String?
    let validTo:String?
    
    let discount:String?
    let discountType:String?
    let couponCode:String?
    let couponImage:String?
    
    let partnerCode:String?
    let name:String?
    let website:String?
    let subCategory:String?
}

