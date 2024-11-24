//
//  PhoneBillChoosePaymentViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 28/01/23.
//

import UIKit

struct PhoneBillChoosePaymentViewModel {

    func getPaymentData(response: @escaping (ResponseModel<PhoneBillPaymentDataModel>?, _ error: Error?) -> Void) {
        
        var url = ""
        
        switch objPhoneBillsManager!.phoneBillType {
        case .DU_Prepaid:
            url = ApiEnd().DU_PREPAID_PAYMENT_URL
            break
        case .DU_Postpaid:
            url = ApiEnd().DU_POSTPAID_PAYMENT_URL
            break
        case .Etisalat_Prepaid:
            url = ApiEnd().ETISALAT_PREPAID_PAYMENT_URL
            break
        case .Etisalat_Postpaid:
            url = ApiEnd().ETISALAT_POSTPAID_PAYMENT_URL
            break
        case .none:
            break
        }
        
        let parameter = self.getParametersForCreateNIOrder()
        print("\n\n\nURL => ", url)
        print(parameter)
      
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<PhoneBillPaymentDataModel>.self) { result, error  in
            response(result, error)

        }
    }
    
    func getParametersForCreateNIOrder() -> [String:Any] {
        var parameter:[String:Any] = [
            "account":objPhoneBillsManager!.phoneBillRequest?.number ?? "",
            "amount":objPhoneBillsManager!.phoneBillRequest?.amount ?? "",
            "transactionId":objPhoneBillsManager!.balanceDataModel?.TransactionId ?? "",
            "payCashback":false,
            "flexiKey":objPhoneBillsManager!.limitDataModel?.flexiKey ?? "",
            "typeKey":"\(objPhoneBillsManager!.limitDataModel?.typeKey ?? 0)",
            "accessKey":objPhoneBillsManager!.limitDataModel?.accessKey ?? ""
            
        ]
       
        switch objPhoneBillsManager?.phoneBillType {
        case .DU_Prepaid:
            parameter["type"] = (objPhoneBillsManager!.phoneBillRequest?.service_type ?? "").lowercased()
            break
        case .DU_Postpaid:
            parameter["lastBalance"] = objPhoneBillsManager?.balanceDataModel?.dueBalanceInAed ?? ""
            parameter["providerTransactionId"] = objPhoneBillsManager?.balanceDataModel?.ProviderTransactionId ?? ""
            break
        case .Etisalat_Prepaid:
            parameter["type"] = (objPhoneBillsManager!.phoneBillRequest?.service_type ?? "").trim()
            parameter["lastBalance"] = objPhoneBillsManager?.balanceDataModel?.CurrentBalance ?? ""
            parameter["providerTransactionId"] = objPhoneBillsManager?.balanceDataModel?.ProviderTransactionId ?? ""
            break
        case .Etisalat_Postpaid:
            parameter["type"] = (objPhoneBillsManager!.phoneBillRequest?.service_type ?? "").trim()
            parameter["lastBalance"] = objPhoneBillsManager?.balanceDataModel?.CurrentBalance ?? ""
            parameter["providerTransactionId"] = objPhoneBillsManager?.balanceDataModel?.ProviderTransactionId ?? ""
            break
            
        case .none:
            break
        }
      return parameter
    }
}
