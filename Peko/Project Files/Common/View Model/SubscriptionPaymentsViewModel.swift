//
//  SubscriptionPaymentsViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 21/07/23.
//

import UIKit

struct SubscriptionPaymentsViewModel {
    
    func getAllProducts(offset:Int, limit:Int, search:String, sortBy:String, response: @escaping (ResponseModel<SubscriptionProductResponseDataModel>??, _ error: Error?) -> Void) {
        
        let url = ApiEnd().SUBSCRIPTION_GET_ALL_PRODUCT + "?draw=1&start=\(offset)&length=\(limit)&searchText="
        
        WSManager.getRequest(url: url, resultType: ResponseModel<SubscriptionProductResponseDataModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    
    func getProductDetail(product_id:Int, response: @escaping (ResponseModel<SubscriptionProductDetailResponseModel>??, _ error: Error?) -> Void) {
    
        let url = ApiEnd().SUBSCRIPTION_GET_PRODUCT_DETAIL + "?productId=\(product_id)"
    //    ?productId=21
        WSManager.getRequest(url: url, resultType: ResponseModel<SubscriptionProductDetailResponseModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    // MARK: -
    func getAllPlans(product_id:Int, response: @escaping (ResponseModel<SubscriptionPlanResponseModel>??, _ error: Error?) -> Void) {
    
        let url = ApiEnd().SUBSCRIPTION_GET_ALL_PLAN + "?productId=\(product_id)"
        
        WSManager.getRequest(url: url, resultType: ResponseModel<SubscriptionPlanResponseModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    
    // MARK: - Order History
    func getOrderHistory(startDate:Date, endDate:Date, offset:Int, limit:Int, search:String, response: @escaping (ResponseModel<SubscriptionHistoryResponseModel>??, _ error: Error?) -> Void) {
        
//        let url = ApiEnd().SUBSCRIPTION_GET_ORDER_HISTORY + "?from=\(startDate.formate()) 00:00:00&to=\(endDate.formate()) 23:59:59&sort=DESC&page=\(offset)&itemsPerPage=\(limit)"
        // &searchText=
      
        let start = "\(startDate.formate()) 00:00:00"
        let end = "\(endDate.formate()) 12:57:54"
        
        let url =  ApiEnd().SUBSCRIPTION_GET_ORDER_HISTORY + "?from=\(start)&to=\(end)&searchText=&sort=DESC&page=\(offset)&itemsPerPage=\(limit)"
        
       // print(response)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<SubscriptionHistoryResponseModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
        
        
//        WSManager.getRequestJSON(urlString: url, withParameter: nil) { success, result in
//            print(result)
//        }
        
        
        
    }
    
    // MARK: - Subscription Payment
    func subscriptionPayment(amount:Double, response: @escaping (ResponseModel<SubscriptionPaymentResponseModel>??, _ error: Error?) -> Void) {
/*
        let formDetails:[String:String] =
        [
            "companyName":(objSubscriptionPaymentManager?.request?.companyName ?? ""),
            "domainName":(objSubscriptionPaymentManager?.request?.domainName ?? ""),
            "adminEmail":(objSubscriptionPaymentManager?.request?.adminEmail ?? ""),
            "address":(objSubscriptionPaymentManager?.request?.address ?? ""),
            "country":(objSubscriptionPaymentManager?.request?.country ?? "")
        ]
        */
        let parameter = self.getParametersForCreateNIOrder(amount: amount)
       
        print(parameter.toJSON())
        
        WSManager.postRequest(url: ApiEnd().SUBSCRIPTION_PAYMENT, param: parameter, resultType: ResponseModel<SubscriptionPaymentResponseModel>.self) { result, error in
            response(result, error)
        }
    }
    
    // MARK: -
    func getParametersForCreateNIOrder(amount:Double) -> [String:Any] {
        let formDetails:[String:String] =
        [
            "companyName":(objSubscriptionPaymentManager?.request?.companyName ?? ""),
            "domainName":(objSubscriptionPaymentManager?.request?.domainName ?? ""),
            "adminEmail":(objSubscriptionPaymentManager?.request?.adminEmail ?? ""),
         //   "address":(objSubscriptionPaymentManager?.request?.address ?? ""),
         //   "country":(objSubscriptionPaymentManager?.request?.country ?? "")
        ]
        
        let parameter = [
            "amount": "\(amount)",
            "planId":"\(objSubscriptionPaymentManager?.plan?.id ?? 0)",
            "formDetails":formDetails,
            "accessKey":"subscription_payments"
        ] as [String : Any]
        
        return parameter
    }
}
