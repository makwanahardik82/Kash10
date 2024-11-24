//
//  InvoiceGeneratorResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit


struct InvoiceGeneratorHistoryResponseDataModel:Codable {
    
    let recordsTotal:Int?
    let invoiceData:[InvoiceGeneratorHistoryModel]?
}



struct InvoiceGeneratorHistoryModel:Codable {
    
    let id:Int?
    
    let recipientDetails:String?
    let invoiceDetails:String?
    
    let productDetails:String?
    let paymentDetails:String?
    let comments:String?
    let termsConditions:String?
    let paymentMode:String?
    let updatedAt:String?
    let createdAt:String?

    var date:Date {
        get {
            return self.createdAt!.dateFromISO8601() ?? Date()
        }
    }
}

struct InvoiceGeneratorDownloadResponseDataModel:Codable {
    
    let pdfBuffer:HotelBookingPdfFileModel?
    
}
