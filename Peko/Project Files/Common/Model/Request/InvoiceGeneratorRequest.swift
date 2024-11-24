//
//  InvoiceGeneratorRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 18/03/24.
//

import UIKit

struct InvoiceDetailsRequest {
   
    var invoiceNumber:String?
    var invoiceDate:Date?
    var dueDate:Date?
    var note:String?
    var terms:String?
    
}

struct InvoiceBillerDetailsRequest {
   
    var logoBase64String:String?
    
    var billerName:String?
    var billerEmail:String?
    var billerMobileNumber:String?
    var billerCompanyAddress:String?
    var billerGstNumber:String?
    
    var customerName:String?
    var customerEmail:String?
    var customerMobileNumber:String?
    var customerAddress:String?
    
}
