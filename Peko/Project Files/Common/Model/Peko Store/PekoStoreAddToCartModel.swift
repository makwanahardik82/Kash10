//
//  PekoStoreAddToCartModel.swift
//  Peko
//
//  Created by Hardik Makwana on 19/05/23.
//

import UIKit

struct PekoStoreAddToCartModel: Codable {
   
    let newCartProduct:Bool?
    let status:String?
    
    
//    let status_code:Int?
//    let message:[String]?
//    let error:String?
//            
    
}
struct PekoStoreUpdateToCartModel: Codable {
   
    let newCartProduct:PekoStoreNewCartProductModel?
    let status:String?
    
}
struct PekoStoreNewCartProductModel: Codable {
    var PekoStoreNewCartProductModel:CustomInt?
}
/*
{
    "success": false,
    "error": "Product already in your cart"
}

 
 {
     "status": true,
     "status_code": 201,
     "message": [
         "Product(s) added to cart successfully"
     ],
     "data": [
         1
     ]
 }
 
 
{
    "success": false,
    "error": "Product already in your cart"
}
 */
