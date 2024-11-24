//
//  ProfileViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 09/04/23.
//

import UIKit


struct ProfileViewModel {

    func updateProfileDetails(otp:String, profileRequest:ProfileRequest, response: @escaping (ResponseModel<ProfileUpdateResponseModel>) -> Void) {
        
        let url = ApiEnd().UPDATE_PROFILE_DETAILS
        
        var parameter :[String:Any] = [
            "name": profileRequest.name ?? "",
            "gender": profileRequest.gender ?? "",
            "dob": profileRequest.selectedDOB?.formate(format: "yyyy-MM-dd") ?? ""
           
       //     "city": profileRequest.emirates ?? "",
       //     "designation": profileRequest.designation ?? "",
        //    "tradeLicenseNo": profileRequest.tradeLicenseNo ?? "",
         //   "issuingAuthority": profileRequest.issuingAuthority ?? "",
        //    "activity": profileRequest.activity ?? "",
         //   "companySize": profileRequest.companySize ?? "",
         //   "trnNo": profileRequest.trnNo ?? "",
         //   "landlineNo": profileRequest.landlineNo ?? "",
           // "otp":otp,
            // "scope":Constants.OTP_SCOPE
      //      "tradeLicenseExpiry" : "2023-12-31",
//            "trdLcnFormat":"png",
//            "trnCertFormat":"png",
//            "eidDocFormat":"png"
        ]
        /*
         "name": "Peko",
             "email":"bhattaasif12@gmail.com",
             "profileImageBase":"BASE64",
             "profileImageFormat":"png",
             "mobileNo":""
         */
        
        
        
        /*
        "":"sap",
             // "mobileNo":333333333333,  //non-editable
             "":"Dubai",
             "designation":"developer",
             // "email":"sample@gmail.com", //non-editable
             "country":"UAE",
             "companyName":"sample",
             "companySize":"1-10",
             "landlineNo":"39847329874",
             "profileImageBase":"base64",
             "profileImageFormat":"png",  //want to update the logo, pass this two
      
              "activity":"TRADING",
          //   "trnExpiry":"2024-06-06 04:00:00",
             "trnNo":"7384973847938",
            // "tradeLicenseExpiry" :"2024-06-06 04:00:00",
             "tradeLicenseNo":"343243243",
      
             "tradeLicenseDoc":"base64",
             "":"png",    //want to update the logo, pass this two
             "trnCertificate":"base64",
             "":"png",     //want to update the logo, pass this two
             "eidDoc":"base64",
             "":"png",    //want to update the logo, pass this two
            
             "otp":"87987",
             "scope":"email"
        
        
        
        if profileRequest.emiratesBaseString.count != 0 {
            parameter["eidDoc"] = profileRequest.emiratesBaseString
            parameter["eidDocFormat"] = "png"
        }
        if profileRequest.tradeLicenseBaseString.count != 0 {
            parameter["tradeLicenseDoc"] = profileRequest.tradeLicenseBaseString
            parameter["trdLcnFormat"] = "png"
        }
        if profileRequest.trnCertificateBaseString.count != 0 {
            parameter["trnCertificate"] = profileRequest.trnCertificateBaseString
            parameter["trnCertFormat"] = "png"
        }
         */
        
        print(parameter.toJSON())
        WSManager.patchRequest(url: url, param: parameter, resultType: ResponseModel<ProfileUpdateResponseModel>.self) { result, error  in
            print(result)
            response(result!)
        }
    }
   // MARK: - Get Address
    func getAddreess(response: @escaping (ResponseModel<AddressResponseDataModel>, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_ADDRESS_LIST
        WSManager.getRequest(url: url, resultType: ResponseModel<AddressResponseDataModel>.self) { result, error  in
            response(result!, error)
        }
    }
   
    func addAddreess(request:AddressRequest, response: @escaping (ResponseModel<AddressModel>, _ error: Error?) -> Void) {
       
         let url = ApiEnd().ADD_ADDRESS
        
        var parameter = [
            "addressType": request.addressType,
            "name": request.fullName,
            "addressLine1": request.addressLine1,
            "addressLine2": request.addressLine2,
            "phoneNumber": request.phoneNumber,
            "default": request.isDefault,
           //  "credentialId": objUserSession.user_id,
            "zipCode":request.zipCode
            
        ] as [String : Any]
        
        if request.id != 0 {
            parameter["id"] = request.id
            
            WSManager.putRequest(url: url, param: parameter, resultType: ResponseModel<AddressModel>.self) { result, error in
                response(result!, error)
            }
        }else{
            WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<AddressModel>.self) { result, error in
                response(result!, error)
            }
        }
     }
    func deleteAddreess(id:Int, response: @escaping (ResponseModel<AddressModel>, _ error: Error?) -> Void) {
        let url = ApiEnd().ADD_ADDRESS + "/\(id)"
        
        WSManager.deleteRequest(url: url, param: [:], resultType: ResponseModel<AddressModel>.self) { result, error in
            response(result!, error)
        }
       
    }
    
    // MARK: - BANK
    func getBankList(response: @escaping (ResponseModel<BankResponseDataModel>, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_BANKS_LIST
        WSManager.getRequest(url: url, resultType: ResponseModel<BankResponseDataModel>.self) { result, error  in
            response(result!, error)
        }
    }
    
    func addUpdateBank(request:AddBankRequest, otpString:String, response: @escaping (ResponseModel<BankModel>, _ error: Error?) -> Void) {
       
         let url = ApiEnd().ADD_BANK
        
        var parameter = [
            
            "accountHolderName": request.accountHolderName,
            "accountNumber": request.accountNumber,
            "accountType": request.accountType,
            "bankAddress": request.bankAddress,
            "bankName": request.bankName,
            "default": request.isDefault,
            "iban": request.ibanNumber,
            "otp": otpString,
            "scope": Constants.OTP_SCOPE,
            "swiftCode": request.swiftCode
            
        ] as [String : Any]
        print(parameter.toJSON())
        
        if request.id != 0 {
            parameter["id"] = request.id
            
            WSManager.putRequest(url: url, param: parameter, resultType: ResponseModel<BankModel>.self) { result, error in
                response(result!, error)
            }
        }else{
            WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<BankModel>.self) { result, error in
                response(result!, error)
            }
        }
     }
    
    func deleteBank(id:Int, response: @escaping (ResponseModel<BankModel>, _ error: Error?) -> Void) {
        let url = ApiEnd().ADD_BANK + "/\(id)"
        
        WSManager.deleteRequest(url: url, param: [:], resultType: ResponseModel<BankModel>.self) { result, error in
            response(result!, error)
        }
       
    }
    
    
    // MARK: -
    func updateMFASettings(param:[String:Any], response: @escaping (ResponseModel<CommonResponseModel>, _ error: Error?) -> Void) {
        
        let url = ApiEnd().UPDATE_MFA_Setting
//        WSManager.getRequest(url: url, resultType: ResponseModel<CommonResponseModel>.self) { result, error  in
//            response(result!, error)
//        }
        WSManager.putRequest(url: url, param: param, resultType: ResponseModel<CommonResponseModel>.self) { result, error  in
            response(result!, error)
        }
    }
    
}

//
