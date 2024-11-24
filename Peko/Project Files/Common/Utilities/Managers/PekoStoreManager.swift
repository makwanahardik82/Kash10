//
//  PekoStoreManager.swift
//  Peko
//
//  Created by Hardik Makwana on 20/05/23.
//

import UIKit

var objPekoStoreManager:PekoStoreManager?

class PekoStoreManager: NSObject {

    static let sharedInstance = PekoStoreManager()
   
    var cartDetailModel:PekoStoreCartDetailModel?
   // var request:PekoStoreOrderRequest?
    var selectedAddress:AddressModel?
    
    var paymentResponseModel:PekoStoreOrderPaymentModel?
}

