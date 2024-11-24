//
//  CommonViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 03/04/24.
//

import UIKit
import NISdk

struct CommonViewModel {
    
    // MARK: - Get Surcharge
    func getSurcharge(amount:Double, accessKey:String, response: @escaping (ResponseModel<SurchargeDataModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_SURCHARGE + "?accessKey=\(accessKey)&amount=\(amount)"
       
        WSManager.getRequest(url: url, resultType: ResponseModel<SurchargeDataModel>.self) { result, error in
            response(result, error)
        }
    }
    
    // MARK: - NI Payment
    func createStripeOrder(param:[String:Any], response: @escaping (ResponseModel<StripeCreateTokenModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_CREATE_STRIPE_ORDER
       
        print(param.toJSON())
       
        WSManager.postRequest(url: url, param: param, resultType: ResponseModel<StripeCreateTokenModel>.self) { result, error in
            response(result, error)
        }
    }
    func getPaymentDetails(paymentRefId:String, response: @escaping (ResponseModel<StripeOrderResponseModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_STRIPE_ORDER_DETAILS + paymentRefId
        print(url)
//        WSManager.getRequestJSON(urlString: url, withParameter: [:]) { success, result in
//            print(result)
//
//            print(result?.toJSON())
//        }
        
        WSManager.getRequest(url: url, resultType: ResponseModel<StripeOrderResponseModel>.self) { result, error in
            response(result, error)
        }
        
        
//        WSManager.postRequest(url: url, param: param, resultType: ResponseModel<NIOrderResponseDataModel>.self) { result, error in
//            response(result, error)
//        }
    }
     /*
    func createNIOrder_Old(param:[String:Any], response: @escaping (ResponseModel<OrderResponse>?, _ error: Error?) -> Void) {
      
        let url = "api/v1/\(objUserSession.role)/\(objUserSession.user_id)/paymentGateway/ni-payments/create-ios"
       
        
        WSManager.postRequest(url: url, param: param, resultType: ResponseModel<OrderResponse>.self) { result, error in
            response(result, error)
        }
    }
    
    */
    
}


struct SurchargeDataModel: Codable {
   
    let surcharge:CustomString?
    let corporateCashback:CustomString?
      
}


struct StripeCreateTokenModel: Codable {
   
    let paymentRefId:CustomInt?
   
    let paymentIntent:String?
    let ephemeralKey:String?
    let customer:String?
    let publishableKey:String?
    
    /*
    "": 1719126757837,
            "": "pi_3PUkbKIIbmH1gI9j16zz4ceS_secret_BZrXnasHfg5hbTUlUh8JYLr4l",
            "": "ek_test_YWNjdF8xTmMyTlNJSWJtSDFnSTlqLDZEU2FuNHIzdW5oMWpMMWZydzJNRzM5MHFtQkRMVWo_00yiRvdYpA",
            "": "cus_QLRU3RN6r20Qoa",
            "": "pk_test_51Nc2NSIIbmH1gI9jiNj7GKoDEiEB1EAHOZQKE4B508wE54JVknWXtyPK6qbm7gDQoeVSGPr0agvkLctIuzkOgpOq00cGKB7NrU"
    */
}

struct StripeOrderResponseModel: Codable {
    
    let customerTxnId:CustomString?
    
    let transactionDate:String?
    let remarks:String?
    let status:String?
    let customerCashback:CustomString?
    
    let order:StripeOrderResponseOrderModel?
    
    var date:Date {
        get {
            return self.transactionDate!.dateFromISO8601() ?? Date()
        }
    }
}
struct StripeOrderResponseOrderModel: Codable {
    let baseAmount:CustomString?
}

