//
//  PekoStoreOrderPaymentModel.swift
//  Peko
//
//  Created by Hardik Makwana on 20/05/23.
//

import UIKit

struct PekoStoreOrderPaymentModel: Codable {
   
    let corporateFinalBalance:String?
    let corporateCashback:String?
    let orderId: CustomInt?

    let datetime: String?
    let amount: CustomDouble?
    let corporateTxnId:CustomInt?

    var date:Date {
        get {
            return self.datetime!.dateFromISO8601() ?? Date()
        }
    }
   
}

//{
//    "success": true,
//    "data": {
//        "": "32377.3169",
//        "": "1",
//        "": "2023-05-20T15:02:07.681Z",
//        "": "20"
//    }
//}
