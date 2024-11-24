//
//  DocumentAttestationRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 06/05/24.
//

import UIKit


struct DocumentAttestationRequest {
    var issueCountry, docType, submissionCountry, selectedIssueCountryCode, selectedSubmissionCountryCode, passportURL:String
}


struct DocumentAttestationAddress {
    var name, country, city, building, zipCode, mobileNumber:String
}
