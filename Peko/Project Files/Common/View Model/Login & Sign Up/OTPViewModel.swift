//
//  OTPViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 26/08/23.
//

import UIKit


struct OTPViewModel {
    func generateOTP(otpRequest: OTPRequest, response: @escaping (ResponseModel<OTPResponseModel>?, _ error: Error?) -> Void) {
        let parameter = [
            "name":otpRequest.name ?? "",
            "mobileNo":objUserSession.mobileCountryCode + otpRequest.mobileNo!,
            "email":otpRequest.email!,
            "scope": Constants.OTP_SCOPE,
         //   "resend":true
        ] as [String : Any]
        
        print("\n\n\nGENERATE OTP => ", parameter.toJSON())
        
        WSManager.postRequest(url: ApiEnd().REGISTER_OTP_URL, param: parameter, resultType: ResponseModel<OTPResponseModel>.self) { result, error  in
         
            response(result, error)
        }
    }
    
    func generateOTPForBeneficiary(type:String, request:BeneficiaryRequest, response: @escaping (ResponseModel<OTPResponseModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().BENEFICIARY_OTP_URL  // + "?scope=\(Constants.OTP_SCOPE)&type=\(type)"
      
        let param = [
            "scope": Constants.OTP_SCOPE,
            "type": type, //EDIT and ADD are the types
            "accessKey": request.accessKey ?? "",
            "accountNo":request.accountNo ?? ""
        ]
        
        WSManager.postRequest(url: url, param:param, resultType: ResponseModel<OTPResponseModel>.self) { result, error in
            response(result, error)
        }
//        WSManager.getRequest(url: url, resultType: ResponseModel<OTPResponseModel>.self) { result, error in
//           // print(result)
//            response(result, error)
//        }
    }
    
    func generateOTPForIndiaBeneficiary(isPostpaid:Bool, type:String, response: @escaping (ResponseModel<OTPResponseModel>?, _ error: Error?) -> Void) {
        
        let accessKey = isPostpaid ? "bbps_telecom_postpaid":"JRI_prepaid"
      //  let type = isUpdateBeneficiary ? "EDIT":"ADD"
      
        let parameter = [
                "scope": Constants.OTP_SCOPE,
                "type": type, //EDIT and ADD are the types
                "accessKey": accessKey
        ]
        
        let url = ApiEnd().BENEFICIARY_OTP_URL
        
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<OTPResponseModel>.self) { result, error in
            // print(result)
             response(result, error)
         }
        
      
//        WSManager.getRequest(url: url, resultType: ResponseModel<OTPResponseModel>.self) { result, error in
//           // print(result)
//            response(result, error)
//        }
    }
    
    
    
    
    
    func generateOTPForUpdate(response: @escaping (ResponseModel<OTPResponseModel>?, _ error: Error?) -> Void) {
        
        let url = ApiEnd().UPDATE_OTP_URL + "?scope=\(Constants.OTP_SCOPE)"
      
        WSManager.getRequest(url: url, resultType: ResponseModel<OTPResponseModel>.self) { result, error in
           // print(result)
            response(result, error)
        }
    }
    
    func generateOTPForBankDetail(request:AddBankRequest ,response: @escaping(ResponseModel<OTPResponseModel>?, _ error: Error?) -> Void) {
        
        var selectedId = ""
        if request.id != 0 {
            selectedId = "\(request.id)"
        }else{
            selectedId = "undefined"
        }
        let url = ApiEnd().BANK_DETAILS_OTP_URL + "?scope=\(Constants.OTP_SCOPE)&accountNumber=\(request.accountNumber)&iban=\(request.ibanNumber)&selectedId=\(selectedId)"
      
        WSManager.getRequest(url: url, resultType: ResponseModel<OTPResponseModel>.self) { result, error in
           // print(result)
            response(result, error)
        }
    }
}
