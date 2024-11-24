//
//  MobilePrepaidRequest.swift
//  Peko India
//
//  Created by Hardik Makwana on 19/12/23.
//

import UIKit


struct MobilePrepaidRequest : Encodable {
    var serviceProvider, location, mobileNumber: String?
    var isPostpaid:Bool?
    var bbpsBillerID:String?
}

