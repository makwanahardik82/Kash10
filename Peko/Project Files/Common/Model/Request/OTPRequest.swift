//
//  OTPRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 25/01/23.
//

import UIKit

struct OTPRequest : Encodable
{
    var email, mobileNo, name: String?
}
