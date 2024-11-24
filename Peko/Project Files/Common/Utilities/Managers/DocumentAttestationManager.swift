//
//  DocumentAttestationManager.swift
//  Peko
//
//  Created by Hardik Makwana on 06/05/24.
//

import UIKit

var objDocumentAttestationManager:DocumentAttestationManager?

class DocumentAttestationManager: NSObject {
    
    static let sharedInstance = DocumentAttestationManager()
   
    var request:DocumentAttestationRequest?
 //   var priceModel:DocumentAttestationPriceModel?
    
    var address:DocumentAttestationAddress?
   // var paymentResponseModel:DocumentAttestationPaymentModel?
    
    
 //   var documentURL:String = ""
}
