//
//  UtilityAddBeneficiaryRequest.swift
//  Peko India
//
//  Created by Hardik Makwana on 28/12/23.
//

import UIKit


struct UtilityAddBeneficiaryRequest : Encodable {
    var name, state, serviceProvider, consumerNumber: String?
}
