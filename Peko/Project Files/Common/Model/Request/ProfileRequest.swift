//
//  ProfileRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 09/04/23.
//

import UIKit

struct ProfileRequest {
    var name,  mobileNumber, email, dob, gender: String?
    // mobileNo, email,
    //var emiratesBaseString, tradeLicenseBaseString, trnCertificateBaseString:String
    var selectedDOB:Date?
}


struct AddressRequest {
    var fullName,  addressLine1, addressLine2, phoneNumber, zipCode, addressType :String
    var isDefault:Bool = false
    var id:Int = 0
}

/*
{
    "": "Asif",
    "": "Rasool",
   
    "": "0504930554",
    "": "asif@peko.one",
  
    "": "Savoll FZ LLC",
   
    "": "TEST123",
    "": "TEST",
    "": "1234543",
   
    "": "Dubai",
    "": "1-10",
    "": "2023-12-31",
   
    
    
    
    "": "",
    "": "12345",
    
   
    "trdLcnFormat":"png",
    "tradeLicenseDoc":"",
    
    "trnCertFormat":"png",
    "trnCertificate":"",
  
    "profileImageBase":"",
    "profileImageFormat":"png"
    
    
    "designation": "CTO",
    "activity": "IT",
   
    
   
  
}
 */
 

