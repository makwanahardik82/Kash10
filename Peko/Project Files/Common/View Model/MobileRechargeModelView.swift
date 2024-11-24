//
//  MobileRechargeModelView.swift
//  Kash10
//
//  Created by Hardik Makwana on 22/06/24.
//

import UIKit


struct MobileRechargeModelView {
    func getOperatorsList(response: @escaping (MobileRechargeOperatorsListResponseModel?, _ error: Error?) -> Void) {
      
        var url = ApiEnd().GET_MOBILE_RECHARGE_OPERATORS_LIST // + "?countryCode=us"
       
       // url = url + "?countryCode=us"
//        
//        if is_live {
//           
//        }
        WSManager.getRequest(url: url, resultType: MobileRechargeOperatorsListResponseModel.self) { result, error in
            response(result, error)
        }
    }
    func getPlansList(product_id:Int,response: @escaping (MobileRechargePlansListResponseModel?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_MOBILE_RECHARGE_PLANS_LIST + "?productId=\(product_id)"
        WSManager.getRequest(url: url, resultType: MobileRechargePlansListResponseModel.self) { result, error in
            response(result, error)
        }
    }
    
    func paymentMobileRecharge(amount:Double, response: @escaping (MobileRechargePaymentResponseModel?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_MOBILE_RECHARGE_PAYMENT
        
        
        let parameter = self.getParametersForCreateOrder(amount: amount)
        WSManager.postRequest(url: url, param: parameter, resultType: MobileRechargePaymentResponseModel.self) { result, error in
            response(result, error)
        }
    }
    
    func getParametersForCreateOrder(amount:Double) -> [String:Any] {
        // objUserSession.mobileCountryCode +
        let mobileNumber =  (objMobileRechargeManager?.mobileNumber ?? "")
      
        let parameter = [
            "skuId":objMobileRechargeManager?.selectedPlanModel?.skuId ?? 0,
            "amount":amount.decimalPoints(point: 2),
            "mobile":mobileNumber,
            "transactionCurrencyCode":objMobileRechargeManager!.selectedPlanModel?.max?.deliveryCurrencyCode ?? "",
            "accessKey":"mobile_topup"
        ] as [String : Any]
        
        print(parameter.toJSON())
       
        return parameter
    }
}
