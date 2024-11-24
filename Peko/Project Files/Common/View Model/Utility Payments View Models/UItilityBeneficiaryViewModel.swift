//
//  UItilityBeneficiaryViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 02/04/23.
//

import UIKit

struct UItilityBeneficiaryViewModel {
 
    func getBalanceData(response: @escaping (ResponseModel<BalanceDataModel>?, _ error: Error?) -> Void) {
        
        var url = ""
        
        switch objUtilityPaymentManager?.utilityPaymentType {
        case .FEWA:
            url = ApiEnd().FEWA_BALANCE_URL + "?"
            break
        case .AADC:
            url = ApiEnd().AADC_BALANCE_URL + "?language=ENG&type=AccountID&"
            break
        case .ADDC:
            url = ApiEnd().ADDC_BALANCE_URL + "?"
            break
        case .Ajman_Sewerage:
            url = ApiEnd().AJMAN_SEWERANGE_BALANCE_URL + "?"
            break
        case .Lootah_Gas:
            url = ApiEnd().LOOTAH_GAS_BALANCE_URL + "?"
            break
//        case .MAWAQiF:
//            //    url = ApiEnd().
//            break
        case .Salik:
            url = ApiEnd().SALIK_BALANCE_URL + "?pin=\(objUtilityPaymentManager?.utilityPaymentRequest?.pin ?? "")&"
            break
        case .Nol_Card:
            url = ApiEnd().NOL_CARD_BALANCE_URL + "?amount=\(objUtilityPaymentManager?.utilityPaymentRequest?.amount ?? "")&"
            break
        case .SEWA:
            url = ApiEnd().SEWA_BALANCE_URL + "?"
            break
        case .none:
            break
        }
        
        url = url + "accountNo=\(objUtilityPaymentManager?.utilityPaymentRequest?.acoountNumber ?? "")&flexiKey=\(objUtilityPaymentManager?.limitDataModel?.flexiKey ?? "")&typeKey=\(objUtilityPaymentManager?.limitDataModel?.typeKey ?? 0)"
       
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<BalanceDataModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    // MARK: - fetchBeneficiary
    func getBeneficiary(response: @escaping (ResponseModel<BeneficiaryResponseDataModel>?, _ error: Error?) -> Void) {
        
        let url = ApiEnd().GET_BENEFICIARY + "?credentialId=\(objUserSession.user_id)&accessKey=\(objUtilityPaymentManager?.limitDataModel?.accessKey ?? "")"
   
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<BeneficiaryResponseDataModel>.self) { result, error in
           // print(result)
            response(result, error)
            
        }
    }
    
    // MARK: - Add Beneficiary
    func addBeneficiary(request:BeneficiaryRequest, otpString:String, response: @escaping (ResponseModel<BeneficiaryModel>?, _ error: Error?) -> Void) {
        
        let parameter = [
            "name":request.name!,
            "accountNo":request.accountNo!,
            "accessKey":request.accessKey!,
            "isActive": "1",
            "credentialId": "\(objUserSession.user_id)",
            "otp":otpString,
            "scope":Constants.OTP_SCOPE
        ]
       
        WSManager.postRequest(url: ApiEnd().ADD_BENEFICIARY, param: parameter, resultType: ResponseModel<BeneficiaryModel>.self) { result, error  in
            response(result!, error)

        }
    }
    // MARK: - Update Beneficiary
    func updateBeneficiary(request:BeneficiaryModel, otpString:String, response: @escaping (ResponseModel<[BeneficiaryModel]>) -> Void) {
        
        let status = request.isActive!.value ? "1" : "0"
        let parameter:[String:Any] = [
            "name":request.name!,
            "accountNo":request.accountNo!,
            "accessKey":request.accessKey!,
            "isActive": status,
            "credentialId": objUserSession.user_id,
            "otp":otpString,
            "scope":Constants.OTP_SCOPE
        ]
       
        WSManager.putRequest(url: ApiEnd().ADD_BENEFICIARY + "\(request.id ?? 0)", param: parameter, resultType: ResponseModel<[BeneficiaryModel]>.self) { result, error in
            print(result)
            response(result!)
        }
    }
    //MARK: - DELETE BENEFICIARY
    func deleteBeneficiary(beneficiary_id:String, response: @escaping (ResponseModel<BeneficiaryModel>?, _ error: Error?) -> Void) {
        
//        let parameter = [
//            "name":request.name!,
//            "accountNo":request.accountNo!,
//            "accessKey":request.accessKey!,
//            "isActive": "1",
//            "credentialId": "\(objUserSession.user_id)"
//        ]
//
        WSManager.postRequest(url: ApiEnd().DELETE_BENEFICIARY + beneficiary_id, param: [:], resultType: ResponseModel<BeneficiaryModel>.self) { result, error  in
            response(result!, error)

        }
    }
    
}
