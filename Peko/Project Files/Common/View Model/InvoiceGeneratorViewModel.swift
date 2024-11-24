//
//  InvoiceGeneratorViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit


struct InvoiceGeneratorViewModel {
    // MARK: -
    func createInvoice(response: @escaping (ResponseModel<InvoiceGeneratorHistoryModel>??, _ error: Error?) -> Void) {
      
        let customerName = (objInvoiceGeneratorManager?.billerDetail?.customerName ?? "")
        let customerEmail = (objInvoiceGeneratorManager?.billerDetail?.customerEmail ?? "")
        let customerAddress = (objInvoiceGeneratorManager?.billerDetail?.customerAddress ?? "")
        let customerPhone = (objInvoiceGeneratorManager?.billerDetail?.customerMobileNumber ?? "")
        
        let recipientDetails = [
            "billerName": objInvoiceGeneratorManager?.billerDetail?.billerName ?? "",
            "billerEmail": objInvoiceGeneratorManager?.billerDetail?.billerEmail ?? "",
            "billerCompanyAddress":objInvoiceGeneratorManager?.billerDetail?.billerCompanyAddress ?? "",
            "billerPhone": objInvoiceGeneratorManager?.billerDetail?.billerMobileNumber ?? "",
            "billerVAT": (objInvoiceGeneratorManager?.billerDetail?.billerGstNumber ?? ""),
            "customerName": customerName,
            "customerEmail": customerEmail,
            "customerAddress": customerAddress,
            "customerPhone": customerPhone
        ]
        
        let invoiceDetails = [
            "invoiceDate": objInvoiceGeneratorManager?.invoiceDetail?.invoiceDate?.formate(format: "dd/mm/yyyy") ?? "", //"01/01/2024",
            "invoiceNo": objInvoiceGeneratorManager?.invoiceDetail?.invoiceNumber ?? "",
            "dueDate": objInvoiceGeneratorManager?.invoiceDetail?.invoiceDate?.formate(format: "dd-mm-yyyy") ?? "", //"31-01-2024",
            "logo": [
                "imageBase":objInvoiceGeneratorManager?.billerDetail?.logoBase64String ?? "",
                "imageFormat": "png"
            ]
        ] as [String : Any]
        
        var productDetailsArray = [Dictionary<String, Any>]()
        
        for model in objInvoiceGeneratorManager!.itemDetailArray {
            let dic = [
                "item": model.desc ?? "",
                "quantity": model.qty ?? "",
                "price": model.price ?? "",
                "vat": model.vat ?? "",
                "discount": model.discount ?? "",
                "amount": model.total ?? ""
            ]
            productDetailsArray.append(dic)
        }
        
        let paymentDetails = [
            "subTotal":objInvoiceGeneratorManager?.subTotal ?? "",
            "total":objInvoiceGeneratorManager?.total ?? "",
            "vat": objInvoiceGeneratorManager?.vat ?? "",
            "discount": objInvoiceGeneratorManager?.discount ?? "",
            "shipping": "",
            "amountDue": objInvoiceGeneratorManager?.total ?? "",
            "amountPaid": ""
        ]
        
        let parameter = [
            "invoiceId": 0,
            "paymentMode":"",
            "recipientDetails":recipientDetails,
            "invoiceDetails":invoiceDetails,
            "productDetails":productDetailsArray,
            "paymentDetails":paymentDetails,
            "comments":objInvoiceGeneratorManager?.invoiceDetail?.note ?? "",
            "termsConditions":objInvoiceGeneratorManager?.invoiceDetail?.terms ?? ""
        ] as [String : Any]
        print(parameter.toJSON())
        
        WSManager.postRequest(url: ApiEnd().CREATE_INVOICE, param: parameter, resultType: ResponseModel<InvoiceGeneratorHistoryModel>.self) { result, error  in
            response(result!, error)
        }
    }

    // MARK: -
    func getAllInvoice(fromDate:Date, toDate:Date, offset:Int, limit:Int = 10 ,response: @escaping (ResponseModel<InvoiceGeneratorHistoryResponseDataModel>??, _ error: Error?) -> Void) {
        
      //  let urlString = ApiEnd().GET_ALL_INVOICE // + "?sort=DESC&start=\(offset)&length=\(limit)&column=id"
        
        let urlString = ApiEnd().GET_ALL_INVOICE + "?fromDate=&toDate=&start=1&length=10&draw=1&order=ASC&column=id&searchText="
       // from=2024-03-04T10:02:45.000Z&to=2024-03-05T06:29:13.000Z&searchText=fdsf&page=1&itemsPerPage=10&sort=DESC
        
        
        WSManager.getRequest(url: urlString, resultType: ResponseModel<InvoiceGeneratorHistoryResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    
    
    // MARK: - Get Download
    func getDownloadInvoice(o_id:Int, response: @escaping (ResponseModel<InvoiceGeneratorDownloadResponseDataModel>?, _ error: Error?) -> Void) {
       // let url = ApiEnd().GET_INVOICE_DOWNLOAD  // + "?orderId=\(o_id)"
        let parameter = [
                "invoiceId" : 628
        ]
        
        WSManager.postRequest(url: ApiEnd().GET_INVOICE_DOWNLOAD, param: parameter, resultType: ResponseModel<InvoiceGeneratorDownloadResponseDataModel>.self) { result, error  in
            response(result!, error)
        }
    }
}
