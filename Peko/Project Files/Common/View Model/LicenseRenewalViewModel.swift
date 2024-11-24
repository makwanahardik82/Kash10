//
//  LicenseRenewalViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 09/05/23.
//

import UIKit

struct LicenseRenewalViewModel {

    func getLimitData(response: @escaping (ResponseModel<LimitDataModel>?, _ error: Error?) -> Void) {
        
        let url = ApiEnd().LICENSE_RENEWAL_LIMIT_URL
        
        WSManager.getRequest(url: url, resultType: ResponseModel<LimitDataModel>.self) { result, error in
            print(result)
            
            response(result, error)
        }
    }
    
    func getBalanceData(number:String, response: @escaping (ResponseModel<LicenseBalanceModel>?, _ error: Error?) -> Void) {
        // ?accountNo=20554148&flexiKey=BP49&typeKey=1
        let url = ApiEnd().LICENSE_RENEWAL_BALANCE_URL + "?accountNo=\(number)&flexiKey=\(objLicenseRenewalManager?.limitDataModel?.flexiKey ?? "")&typeKey=\(objLicenseRenewalManager?.limitDataModel?.typeKey ?? 0)"
       
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<LicenseBalanceModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    
    func payment(amount:Double, response: @escaping (ResponseModel<LicensePaymentResponseModel>?, _ error: Error?) -> Void) {
       
        let url = ApiEnd().LICENSE_RENEWAL_PAYMENT_URL
      //  let timestamp = Date().timeIntervalSince1970

      
        var parameter = self.getParametersForCreateNIOrder(amount: amount)
        
        print(parameter.toJSON())
        
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<LicensePaymentResponseModel>.self) { result, error  in
            response(result, error)
        }
    }
    func getParametersForCreateNIOrder(amount:Double) -> [String:Any] {
        
        let eid:Int = Int(objLicenseRenewalManager?.emiratesID ?? "0")!
        let parameter = [
            "account": objLicenseRenewalManager?.balanceDataModel?.AccountNumber ?? "",
            "transactionId": objLicenseRenewalManager?.balanceDataModel?.TransactionId ?? "",
            "amount": amount,
            "payCashback": false,
            "flexiKey": objLicenseRenewalManager?.limitDataModel?.flexiKey ?? "",
            "typeKey": objLicenseRenewalManager?.limitDataModel?.typeKey ?? 0,
            "emiratesId":eid,
            "accessKey":"dubai_ded",
            "customerName":objLicenseRenewalManager?.customerName ?? ""
        ] as [String : Any]
        return parameter
    }
    
    
}
