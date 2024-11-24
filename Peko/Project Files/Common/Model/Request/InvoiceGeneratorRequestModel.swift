//
//  InvoiceGeneratorRequestModel.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit

struct InvoiceGeneratorRequestModel {
    
    var logoImage:UIImage?
    var companyName:String?
    var billTo:String?
    var invoiceNumber:String?
    var paymentTerms:String?
    var poNumber:String?
   
    var invoiceDate:Date?
    var dueDate:Date?
    
    var tax:String?
    var discount:String?
    var shipping:String?
    var amountPaid:String?
   
    var notes:String?
    var termsCondition:String?
    var vatNumber:String?
    var modePayment:String?
    
    var itemDetailsArray = [InvoiceItemDetailModel]()
    
    var subTotal = 0.0
    var total = 0.0
    var balance = 0.0
}
