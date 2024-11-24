//
//  InvoiceGeneratorValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit

struct InvoiceGeneratorValidation {
    
    // MARK: - Biller Detail
    func ValidateBillerDetails(request: InvoiceBillerDetailsRequest) -> AppValidationResult
    {
        if (request.logoBase64String!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please upload logo")
        }
        if (request.billerName!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the biller name")
        }
        if (request.billerEmail!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the biller email")
        }
        if !(request.billerEmail!.isValidEmail ) {
            return AppValidationResult(success: false, error: "Please enter valid biller email")
        }
        if (request.billerMobileNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the biller mobile number")
        }
        if (request.billerCompanyAddress!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the company address")
        }
//        if (request.billerGstNumber!.isEmpty)
//        {
//            return AppValidationResult(success: false, error: "Please enter the GST number")
//        }
        
        if (request.customerName!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the customer name")
        }
        if (request.customerEmail!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the customer email")
        }
        if !(request.customerEmail!.isValidEmail ) {
            return AppValidationResult(success: false, error: "Please enter valid customer email")
        }
        if (request.customerMobileNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the customer mobile number")
        }
        if (request.customerAddress!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the customer address")
        }
       
        return AppValidationResult(success: true, error: nil)
    }
    
    // MARK: - Invoice Detail
    func ValidateInvoiceDetails(request: InvoiceDetailsRequest) -> AppValidationResult
    {
        if (request.invoiceNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter the invoice number")
        }
        if (request.invoiceDate == nil)
        {
            return AppValidationResult(success: false, error: "Please enter the invoice date")
        }
        if (request.dueDate == nil)
        {
            return AppValidationResult(success: false, error: "Please enter the due date")
        }
       
        return AppValidationResult(success: true, error: nil)
    }
    
    // MARK: - Item
    func ValidateItem(item: InvoiceItemDetailModel) -> AppValidationResult
    {
        if((item.desc!.isEmpty))
        {
            return AppValidationResult(success: false, error: "Please enter the description")
        }
        if((item.qty!.isEmpty))
        {
            return AppValidationResult(success: false, error: "Please enter the quantity")
        }
        if(item.price!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter a price")
        }
        if((item.vat!.isEmpty))
        {
            return AppValidationResult(success: false, error: "Please enter a VAT")
        }
        if((item.discount!.isEmpty))
        {
            return AppValidationResult(success: false, error: "Please enter a discount")
        }
        return AppValidationResult(success: true, error: nil)
    }
    /*
    func ValidateCreate(request: InvoiceGeneratorRequestModel) -> AppValidationResult
    {
        /*
        if(request.companyName!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter company name and address")
        }
        if(request.billTo!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter bill to")
        }
        if(request.invoiceDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select invoice date")
        }
        
        if(request.invoiceNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter invoice number")
        }
        if(request.paymentTerms!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter payment terms")
        }
        if(request.dueDate == nil)
        {
            return AppValidationResult(success: false, error: "Please select due date")
        }
        if(request.poNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter PO number")
        }
        */
        
        for j in 0..<(request.itemDetailsArray.count ) {
            
            let item = request.itemDetailsArray[j] // as? InvoiceItemDetailModel{
            if((item.desc?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter the description or product of a item \(j + 1)")
            }
            if((item.qty?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter the quantity of a item \(j + 1)")
            }
            if((item.price?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter a price of a item \(j + 1)")
            }
            if((item.vat?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter a VAT of a item \(j + 1)")
            }
            if((item.discount?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter a discount of a item \(j + 1)")
            }
        }
        
        return AppValidationResult(success: true, error: nil)
    }
    // MARK: -
    func ValidateGanerator(request: InvoiceGeneratorRequestModel) -> AppValidationResult
    {
        for j in 0..<(request.itemDetailsArray.count ) {
           
            let item = request.itemDetailsArray[j] // as? InvoiceItemDetailModel{
            if((item.desc?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter the description or product of a item \(j + 1)")
            }
            if((item.qty?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter the quantity of a item \(j + 1)")
            }
            if((item.price?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter a price of a item \(j + 1)")
            }
            if((item.vat?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter a VAT of a item \(j + 1)")
            }
            if((item.discount?.isEmpty) != nil)
            {
                return AppValidationResult(success: false, error: "Please enter a discount of a item \(j + 1)")
            }
        }
        
        if(request.amountPaid!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter amount paid")
        }
        if(request.modePayment!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select mode of payment")
        }
        
        return AppValidationResult(success: true, error: nil)
    }
    */
}
