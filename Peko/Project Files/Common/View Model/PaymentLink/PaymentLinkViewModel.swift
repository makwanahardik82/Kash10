//
//  PaymentLinkViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 21/05/23.
//

import UIKit

struct PaymentLinkViewModel {
    
    // MARK: - Create Link
    func createLink(request:PaymentsLinksRequest, response: @escaping (PaymentLinkCreateResponseModel?, _ error: Error?) -> Void) {
       
        let url = ApiEnd.PAYMENT_LINK_GETLINK_URL
  
        let parameter = [
            "amount":request.amount ?? "",
            "purpose":"",
            "customer_email":request.email ?? "",
            "customer_phone":request.phoneNumber ?? "",
            "createdAt":request.createDate ?? "",
            "linkDateExpiry":request.expiryDate ?? "",
            "note":request.note ?? ""
        ]
      
        WSManager.postRequest(url: url, param: parameter, resultType: PaymentLinkCreateResponseModel.self) { result, error  in
            response(result!, error)

        }
    }
    
    func getHistory(fromDate:Date, toDate:Date, response: @escaping (PaymentLinkHistoryResponseModel?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().PAYMENT_LINK_HISTORY_URL + "?fromDate=\(fromDate.formate()) 00:00:00&toDate=\(toDate.formate()) 23:59:59" + "&orderCol=DESC&column=createdAt&length=10&start=0"
        
        
      //  {{local_url}}/api/v1/paymentLinks/23/history?fromDate=2023-04-01 00:00:00&toDate=2023-05-12 23:59:59
        
        
        WSManager.getRequest(url: url, resultType: PaymentLinkHistoryResponseModel.self) { result, error in
            response(result, error)
        }
    }
    
}
