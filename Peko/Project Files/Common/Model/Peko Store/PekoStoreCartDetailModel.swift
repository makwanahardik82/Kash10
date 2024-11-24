//
//  PekoStoreCartDetailModel.swift
//  Peko
//
//  Created by Hardik Makwana on 19/05/23.
//

import UIKit

struct PekoStoreCartDetailModel: Codable {
   
    let success:Bool?
   
    let status:Bool?
    let status_code:Int?
    let message:[String]?
    let error:String?
    
    let allowCheckout:Bool?
    let itemsTotalAmount:CustomDouble?
    let grandTotal:CustomDouble?
    let totalVat:CustomDouble?
    let shippingCharge:CustomDouble?
    let eligibleFreeShipping:CustomDouble?
    let freeDelivery:Bool?
    
    let count:Int?
    let cartId:Int?
    
    let items:[PekoStoreCartModel]?
   
}
struct PekoStoreCartModel: Codable {
    
    let id:Int?
    let price:CustomDouble?
    let totalPrice:CustomDouble?
    let totalVat:CustomDouble?
   
    let productQuantity:Int?
    let productQuantityInDB:Int?
   
    let name:String?
    let SKUCode:String?
    let productImage:String?
    let brand:String?
    let VAT:String?
    let vatType:String?
 
}
/*
{
    "status": true,
    "status_code": 200,
    "message": [
        "All product(s) in your cart"
    ],
    
    "": 2089,
    "": true,
    "": 2089
    
    "": 2,
    "": 312,
    "data": [
        {
            "id": 2,
            "name": "Macbook",
            "SKUCode": "1001",
            "price": 1000,
            "productImage": "https://firebasestorage.googleapis.com/v0/b/peko-a2d2f.appspot.com/o/profile%2Fimages%2F1677030387508.jpeg?alt=media&token=7b67888d-31d5-49e7-9ff3-bc8a98d09d55",
            "productQuantity": 2,
            "totalPrice": 2000,
            "productQuantityInDB": 6
        },
        {
            "id": 22,
            "name": "vaan",
            "SKUCode": "798789",
            "price": 89,
            "productImage": null,
            "productQuantity": 1,
            "totalPrice": 89,
            "productQuantityInDB": 79
        }
    ],
    
}

*/
