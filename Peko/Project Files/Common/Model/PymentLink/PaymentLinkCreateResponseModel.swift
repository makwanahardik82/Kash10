//
//  PaymentLinkCreateResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 21/05/23.
//

import UIKit

struct PaymentLinkCreateResponseModel: Codable {
   
    var status:Bool?
    var success:Bool?
//    var status_code:Int?
    
    var message:String?
    var error:String?
    var data:String?
}

/*
{
    "status": true,
    "status_code": 201,
    "message": "Link Generated Successfully",
    "data": "https://secure.telr.com/gateway/ql/PekoPaymentServicesAirT_593005.html"
}
*/
