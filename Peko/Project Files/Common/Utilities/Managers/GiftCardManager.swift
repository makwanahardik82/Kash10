//
//  GiftCardManager.swift
//  Peko
//
//  Created by Hardik Makwana on 13/05/23.
//

import UIKit


var objGiftCardManager:GiftCardManager?

class GiftCardManager: NSObject {

    static let sharedInstance = GiftCardManager()
   
    var productUAEModel:GiftCardProductModel?
//    var productIndiaModel:GiftCardProductIndiaModel?
    
    var amount:Double = 0.0
    var quality:Int = 1
    var address:AddressModel?
    
    var addressRequest:GiftCardRequest?
    
//    var dapiPaymentResponse:[String:Any]?
//    var dapiAmount:String = "0"
}
