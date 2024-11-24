//
//  SignUpRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 23/01/23.
//

import UIKit


struct SignUpRequest : Encodable
{
    var first_name, last_name, mobile_number, company_name, city, sector, country_name, country_code, email, designation, password, confirm_password: String?
}

