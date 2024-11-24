//
//  InvoiceGeneratorManager.swift
//  Peko
//
//  Created by Hardik Makwana on 18/03/24.
//

import UIKit

var objInvoiceGeneratorManager:InvoiceGeneratorManager?

class InvoiceGeneratorManager: NSObject {
    
    static let sharedInstance = InvoiceGeneratorManager()
   
    var billerDetail:InvoiceBillerDetailsRequest?
    var invoiceDetail:InvoiceDetailsRequest?
    var itemDetailArray = [InvoiceItemDetailModel]()
    
    var subTotal:String?
    var total:String?
    var vat:String?
    var discount:String?
    
}
