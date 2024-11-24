//
//  PhoneBillBeneficiaryViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 28/01/23.
//

import UIKit

struct PhoneBillBeneficiaryViewModel {

    func getBalanceData(response: @escaping (ResponseModel<BalanceDataModel>?, _ error: Error?) -> Void) {
        
        var url = ""
        
        switch objPhoneBillsManager?.phoneBillType {
        case .DU_Prepaid:
            url = ApiEnd().DU_PREPAID_BALANCE_URL
            break
        case .DU_Postpaid:
            url = ApiEnd().DU_POSTPAID_BALANCE_URL
            break
        case .Etisalat_Prepaid:
            url = ApiEnd().ETISALAT_PREPAID_BALANCE_URL
            break
        case .Etisalat_Postpaid:
            url = ApiEnd().ETISALAT_POSTPAID_BALANCE_URL
            break
        case .none:
            break
        }
        
        url = url + "?accountNo=\(objPhoneBillsManager?.phoneBillRequest?.number ?? "")&flexiKey=\(objPhoneBillsManager?.limitDataModel?.flexiKey ?? "")&typeKey=\(objPhoneBillsManager?.limitDataModel?.typeKey ?? 0)"
        
        
        switch objPhoneBillsManager?.phoneBillType {
        case .DU_Prepaid:
           
            break
        case .DU_Postpaid:
           
            break
        case .Etisalat_Prepaid:
            url = url + "&type=\((objPhoneBillsManager!.phoneBillRequest?.service_type ?? "").trim())"
            
            break
        case .Etisalat_Postpaid:
            url = url + "&type=\((objPhoneBillsManager!.phoneBillRequest?.service_type ?? "").trim())"
            break
            
        case .none:
            break
        }
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<BalanceDataModel>.self) { result, error in
         //   print(result)
            response(result, error)
        }
    }
    // MARK: - fetchBeneficiary
    func getBeneficiary(response: @escaping (ResponseModel<BeneficiaryResponseDataModel>?, _ error: Error?) -> Void) {
        // credentialId=\(objUserSession.user_id)&
        let url = ApiEnd().GET_BENEFICIARY + "?accessKey=\(objPhoneBillsManager?.limitDataModel?.accessKey ?? "")"
   
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<BeneficiaryResponseDataModel>.self) { result, error in
        //    print(result)
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
            response(result!,error)

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
        let url = ApiEnd().DELETE_BENEFICIARY + beneficiary_id
        WSManager.deleteRequest(url: url, param: [:], resultType: ResponseModel<BeneficiaryModel>.self) { result, error  in
            response(result!, error)

        }
    }
}
