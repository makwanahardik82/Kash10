//
//  MobileAddBeneficiaryRequest.swift
//  Peko India
//
//  Created by Hardik Makwana on 26/12/23.
//

import UIKit


struct MobileAddBeneficiaryRequest : Encodable {
    var name, serviceProvider, mobileNumber: String?
}
