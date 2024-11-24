//
//  PaymentsLinksRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 21/05/23.
//

import UIKit

struct PaymentsLinksRequest {
    var name, amount, email, phoneNumber, createDate, expiryDate, note: String?
    var noExpiry:Bool = false
    var imageBase64String:String
    // description
}
