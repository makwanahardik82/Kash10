//
//  UtilityPaymentChooseViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 02/04/23.
//

import UIKit

struct UtilityPaymentChooseViewModel {

    func getPaymentData(finalAmount:Double, response: @escaping (ResponseModel<PhoneBillPaymentDataModel>?, _ error: Error?) -> Void) {
       
        var url = ""
        
        switch objUtilityPaymentManager?.utilityPaymentType {
        case .FEWA:
            url = ApiEnd().FEWA_PAYMENT_URL
            break
        case .AADC:
            url = ApiEnd().AADC_PAYMENT_URL
            break
        case .ADDC:
            url = ApiEnd().ADDC_PAYMENT_URL
            break
        case .Ajman_Sewerage:
            url = ApiEnd().AJMAN_SEWERANGE_PAYMENT_URL
            break
        case .Lootah_Gas:
            url = ApiEnd().LOOTAH_GAS_PAYMENT_URL
            
            break
        case .Salik:
            url = ApiEnd().SALIK_PAYMENT_URL
            break
        case .Nol_Card:
            url = ApiEnd().NOL_CARD_PAYMENT_URL
            break
        case .SEWA:
            url = ApiEnd().SEWA_PAYMENT_URL
            break
//        case .DubaiPolice:
//            url = ApiEnd().DUBAI_POLICE_PAYMENT_URL
//        case .Darb:
//            url = ApiEnd().DARB_PAYMENT_URL
//            break
//        case .Hafilat:
//            url = ApiEnd().HAFILAT_PAYMENT_URL
//            break
        case .none:
            break
        }
        
        let parameter:[String:Any] = self.getParametersForCreateNIOrder(amount: finalAmount)
        print(parameter.toJSON())
      
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<PhoneBillPaymentDataModel>.self) { result, error  in
            response(result!, error)
        }
    }
    
    func getParametersForCreateNIOrder(amount:Double) -> [String:Any] {
        
        var parameter:[String:Any] = [
            "account":objUtilityPaymentManager!.utilityPaymentRequest?.acoountNumber ?? "",
            "amount":amount,
            "transactionId":objUtilityPaymentManager!.balanceDataModel?.TransactionId ?? "",
            "payCashback":false,
            "flexiKey":objUtilityPaymentManager!.limitDataModel?.flexiKey ?? "",
            "typeKey":"\(objUtilityPaymentManager!.limitDataModel?.typeKey ?? 0)",
            "accessKey":objUtilityPaymentManager!.limitDataModel?.accessKey ?? ""
        ]
        
        switch objUtilityPaymentManager?.utilityPaymentType {
        case .FEWA:
            break
        case .AADC:
            break
        case .ADDC:
            break
        case .Ajman_Sewerage:
            break
        case .Lootah_Gas:
            parameter["contractId"] = objUtilityPaymentManager?.balanceDataModel?.GasAccountNo ?? ""
            break
        case .Salik:
            parameter["pin"] = objUtilityPaymentManager?.utilityPaymentRequest?.pin ?? ""
            parameter["providerTransactionId"] = objUtilityPaymentManager?.balanceDataModel?.ProviderTransactionId ?? ""
            break
        case .Nol_Card:
            break
        case .SEWA:
            break
            /*
        case .DubaiPolice:
            break
        case .Darb:
            let wallet = objUtilityPaymentManager?.balanceDataModel?.WalletDetails?.first
            parameter["optional1"] = wallet?.walletIdentity ?? ""
         
        case .Hafilat:
            let productDetail = objUtilityPaymentManager?.balanceDataModel?.ProductDetails?.first
         
            let optionals = [
                "ProductCode": productDetail?.ProductCode ?? "",
                "isTPurse": productDetail?.ProductTitle ?? "",
                "customerMobileNo": ""
            ]
            parameter["accessKey"] = "hafilat"
            parameter["optionals"] = optionals
         */
        case .none:
            break
        }
        return parameter
    }
}
