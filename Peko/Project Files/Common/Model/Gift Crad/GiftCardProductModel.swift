//
//  GiftCardProductModel.swift
//  Peko
//
//  Created by Hardik Makwana on 10/05/23.
//

import UIKit

struct GiftCardProductDataModel: Codable {
   
    let count:Int?
    var rows:[GiftCardProductModel]?
    
//    let productsCount:Int?
//    var products:[GiftCardProductModel]?
  
    /*
    let id:Int?
    var name:String?
    var url:String?
    var description:String?
    var productsCount:Int?
    var products:[GiftCardProductModel]?
    
    "images": {
        "image": null,
        "thumbnail": null
    },
    */
            
}
struct GiftCardProductImagesModel: Codable {
    
    var thumbnail:String?
    var mobile:String?
    var base:String?
    var small:String?
}

struct GiftCardCurrencyModel: Codable {
    var code:String?
    var symbol:String?
    var numericCode:String?
}
struct GiftCardProductPriceModel: Codable {
    
    var price:String?
    var type:String?
    var min:String?
    var max:String?
    
    var denominations:[CustomString]?
    var currency:GiftCardCurrencyModel?
//    
//    "currency": {
//                    "code": "INR",
//                    "symbol": "₹",
//                    "numericCode": "356"
//                },
    
//    var mobile:String?
//    var base:String?
//    var small:String?
    
}
/*
"price": {
            "": "RANGE",
            "": "RANGE",
            "": "1000",
            "": "10000",
            "": [
                "1",
                "100",
                "1000",
                "2000",
                "3000",
                "4000",
                "5000",
                "6000",
                "7000",
                "8000",
                "9000",
                "10000"
            ],
            "currency": {
                "code": "INR",
                "symbol": "₹",
                "numericCode": "356"
            },
            "cpg": []
        }

*/
struct TNCModel: Codable {
    var link:String?
    var content:String?
}

struct GiftCardProductImageModel: Codable {
    var thumbnail:String?
    var mobile:String?
    var base:String?
    var small:String?
}

struct GiftCardProductModel: Codable {
    
  //  var id:CustomInt?
    var status:Int?
    
    
    var product_id:CustomInt?
    var name:String?
    var image:String?
    
    var description:String?
    var redemption_instructions:String?
    var term_and_conditions:String?
    
    var note:String?
  
    var minDenomination:String?
    var maxDenomination:String?
    var priceType:String?
    var currency:String?
    
    var denominations:[CustomDouble]?
   
    /*
    var brand_code:String?
    
    var activation_fee:String?
  //  var currency:String?
    var redemption_instructions:String?
   
    var serviceOperatorId:Int?
    
    var createdAt:String?
    var updatedAt:String?
   
    
    var sku:String?
    var url:String?
    
    var minPrice:String?
    var maxPrice:String?
    
    var images:GiftCardProductImageModel?
    
    
    "": 1053,
                  "name": "GrubHub US",
                  "image": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1719116401021.jpeg?alt=media&token=2b39c872-8edc-4132-8fc9-b28afecdda8c",
                  "description": null,
                  "notes": null,
                  "minDenomination": "5.00",
                  "maxDenomination": "1,000.00",
                  "priceType": "FLEXI",
                  "currency": "USD"
    
    */
}

struct GiftCardProductDataIndiaModel: Codable {
    
    let count:Int?
    var rows:[GiftCardProductIndiaModel]?
}

struct GiftCardProductIndiaModel: Codable {
    
    var id:CustomInt?
    var status:Int?
    
    var product_id:String?
    var product_name:String
    
    var merchant_id:String?
    var merchant_name:String?
   
    var brand_name:String?
    var brand_logo:String?
   
    
    var mrp:String?
    var selling_price:String?
    var min_price:String?
    var max_price:String?
   
    var expiry:String?
    var gv_type:String?
    
    var is_open_denominnation:CustomInt?

    var terms_and_condition:String?
    var how_to_redeem:String?
    
    var createdAt:String?
    var updatedAt:String?
    
}

struct GiftCardHistoryResponseDataModel: Codable {
    var totalData:Int?
    var result:[GiftCardHistoryModel]?
}
struct GiftCardHistoryModel: Codable {
    
    let customerTxnId:String?
    let transactionDate:String?
    let transactionCategory:String?
    let status:String?
    let remarks:String?
   
    let order:GiftCardOrderHistoryModel?
}
struct GiftCardOrderHistoryModel: Codable {
    
    let id:Int?
    let amountInAed:String?
    let paymentMode:String?
    let status:String?
    let ecomOrderStatus:String?
    let remtransactionDatearks:String?
    let customerTxnId:String?
   
    var orderResponse:GiftCardOrderResponseHistoryModel?
    
}
struct GiftCardOrderResponseHistoryModel: Codable {
    var value:GiftCardOrderResponseValueHistoryModel?
}
struct GiftCardOrderResponseValueHistoryModel: Codable {
    let name:String?
    let image:String?
    let notes:String?
    let currency:String?
    let priceType:String?
    let maxDenomination:String?
    let minDenomination:String?
    let product_id:Int?
    let description:String?
}

